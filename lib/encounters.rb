# Parse out individual encounters within a video
class Encounters
  MIN_SILENCE = 30_000

  def initialize(subs)
    @subs = subs

    # A language encounter can occur at the same time as another
    # language, for instance, switching between Cantonese and Mandarin
    # with one person.
    @encounters = {}
  end

  def find
    @subs.each do |sub|
      @sub = sub
      analyse_sub
    end
    @encounters
  end

  def analyse_sub
    return if @sub[:language].nil?
    if new_language_encounter?
      start_new_language_encounter
    else
      update_language_encounter
    end
  end

  # Decide whether this is a new encounter or not. It's not really
  # foolproof. We're doing something crude like;
  # An encounter starts when a subtitle of a language occurs within
  # a given window of time since the last subtitle of that language.
  def new_language_encounter?
    # Well it's *definitely* true if there's absolutely no records
    # of this language yet.
    return true unless @encounters.key? @sub[:language]

    # Crudely define a repeat encounter of a language when there's been
    # more than MIN_SILENCE seconds since the last utterance of that
    # language.
    tracked_language = @encounters[@sub[:language]].last
    time_of_previous_utterance = tracked_language[:current][:time]
    time_since_last_utterance = time_of_previous_utterance - @sub[:time]
    time_since_last_utterance > MIN_SILENCE
  end

  def start_new_language_encounter
    recurrences = handle_language_occurences
    @encounters[@sub[:language]][recurrences] = {
      # The subtitle data for the first utterance of the encounter
      start: @sub,
      # For keeping track of the utterance until we can be sure of
      # when the end occurs.
      current: @sub
    }
  end

  # Check to see if this is the first encounter of this language, if not
  # return how many times this language has already appeared.
  def handle_language_occurences
    @encounters[@sub[:language]] ||= []
    # Recall that arrays are zero-indexed so we don't need to increment
    # `recurrences`, in effect `.length()` already does the increment.
    @encounters[@sub[:language]].length
  end

  def update_language_encounter
    @encounters[@sub[:language]].last[:current] = @sub
  end
end
