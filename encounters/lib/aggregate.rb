require 'date'
require_relative 'download'
require_relative 'parse_subs'
require_relative 'encounters'

# Bring everything together from all files into a consumable JSON hash.
class Aggregate
  VTT_PATH_PATTERN = 'encounters/sub_files/*.vtt'.freeze

  attr_accessor :all

  def initialize
    @all = {}
  end

  def self.download
    DownloadVideoMeta.download
  end

  def compile_all
    files = Dir.glob(VTT_PATH_PATTERN)

    files.each do |file|
      @file = file
      subs = ParseSubs.parse @file
      clean Encounters.new(subs).find
    end
    remove_languages_with_one_encounter
    sort_by_number_of_encounters
    sort_by_encounter_dates
  end

  def current_video_filename_parts
    File.basename(@file).split '__'
  end

  def current_video_id
    current_video_filename_parts[0]
  end

  def current_video_title
    current_video_filename_parts[1]
  end

  def current_video_date
    date = current_video_filename_parts[2]
    date.nil? ? '' : Date.parse(date).to_s
  end

  def clean(encounters)
    # Encounters are grouped by language
    encounters.each do |language, language_encounters|
      language_encounters.each do |raw_encounter|
        @encounter = raw_encounter
        @all[language] ||= {
          encounters: []
        }
        @all[language][:encounters] << compile_encounter
      end
    end
  end

  def compile_encounter
    {
      video_id: current_video_id,
      title: current_video_title,
      date: current_video_date,
      start: generate_youtube_time,
      duration: calculate_duration,
      opener: parse_opener
    }
  end

  def generate_youtube_time
    seconds = @encounter[:start][:time] / 1000
    seconds.to_i
  end

  def calculate_duration
    milliseconds = @encounter[:current][:time] - @encounter[:start][:time]
    (milliseconds / 1000).to_i
  end

  def parse_opener
    @encounter[:start][:text].gsub(/\(\((.*)\)\) /, '')
  end

  def remove_languages_with_one_encounter
    @all = @all.delete_if { |_, v| v[:encounters].length == 1 }
  end

  def sort_by_number_of_encounters
    @all = Hash[@all.sort_by { |_, v| -v[:encounters].length }]
  end

  def sort_by_encounter_dates
    @all.each do |language, language_encounters|
      ascending_date = language_encounters[:encounters].sort_by { |e| e[:date] }
      @all[language][:encounters] = ascending_date.reverse
    end
  end

  def save_to_disk
    File.open('static/encounters.json', 'w') do |f|
      f.puts @all.to_json
    end
  end
end
