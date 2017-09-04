# Given a `.vtt` file, convert it into a friendly hash
class ParseSubs
  class << self
    # This is the pattern we're working with:
    #
    # 0:0:0.000 --> 0:0:1.123
    # ((MANDARIN)) How are you?
    # \n
    #
    # Here we make it ruby friendly with something like:
    # [{
    #   time: 1123,
    #   text: '((MANDARIN)) How are you?'
    #   language: :mandarin
    # }, ...]
    def parse(file)
      subs = []
      time = false
      File.readlines(file).each do |line|
        next if line.strip == ''
        subs << build_sub_hash(line, time) if time
        time = line =~ /-->/ ? timestamp(line) : false
      end
      subs
    end

    def build_sub_hash(line, time)
      {
        time: time,
        text: line.strip,
        language: parse_language_name(line)
      }
    end

    # Convert something like '0:0:1.123' to 1123
    def timestamp(time)
      start = time.split(' ')[0]
      secs = start.split(':').last.to_f
      mins = start.split(':')[1].to_i
      hours = start.split(':')[0].to_i
      build_time secs, mins, hours
    end

    # Maaaaths
    def build_time(secs, mins, hours)
      (hours * 60 * 60 * 1000) + (mins * 60 * 1000) + (secs * 1000)
    end

    # Eg; extract `:mandarin` from '((MANDARIN))'
    def parse_language_name(text)
      matches = text.match(/\(\((.*)\)\)/)
      matches.captures.first.downcase.to_sym if matches
    end
  end
end
