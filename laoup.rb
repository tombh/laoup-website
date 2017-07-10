$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pp'

require 'lib/download'
require 'lib/parse'
require 'lib/encounters'

# DownloadVideoMeta.download

subs = ParseSubs.parse 'tmp/0QEWp7c3yMo.en.vtt'
encounters = Encounters.new(subs).find

encounters.each do |language, language_encounters|
  language_encounters.each do |encounter|
    seconds = encounter[:start][:time] / 1000
    minutes = (seconds / 60).floor.to_i
    seconds_remainder = seconds.to_i - (minutes * 60)
    time = "#{minutes}m#{seconds_remainder}"
    p "#{language}: https://www.youtube.com/watch?v=0QEWp7c3yMo#t=#{time}"
  end
end
