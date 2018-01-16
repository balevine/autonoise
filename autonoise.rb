# Use rubysynth for tone generation and sequencing
require_relative 'rubysynth/RubySynth'

# Notes:
# Items to programmatically determine
# - song key
# - song bpm
# - song scale
# - note key
# - note duration
# - note octave
# - instrument base oscillator (sine, sawtooth, square, noise)
# - instrument base oscillator bit rate
# - instrument base oscillator frequency
# - instrument base oscillator amplitude
# - instrument overtones (number of overtones)
# - instrument vibrato LFO oscillator (type, bit rate, freq, and amplitude)
# - instrument volume LFO oscillator (type, bit rate, freq, and amplitude)

def convert_to_character_code(word)
  code_array = []
  word.each_char do |character|
   character_code = character.ord
   code_array.push(character_code)
  end
  average_code = code_array.inject(0.0) { |sum, el| sum + el } / code_array.size
  average_code = average_code.ceil
end

def get_note_and_octave(tone, root_index)
  # Use the author key as the root
  # Select from the following scales
  # - Minor
  # more to come later

  step = tone % 7
  octave = (tone/7) - 1

  notes = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']

  # Reorder notes array based on root key
  chromatic_index = notes.each_index.select { |i| i >= root_index }
  chromatic_index = chromatic_index + notes.each_index.select { |i| i < root_index }

  chromatic_key = []
  chromatic_index.each do |i|
    chromatic_key.push(notes[i])
  end

  # Minor key in root key
  minor_key = chromatic_key.values_at(0,2,3,5,7,8,10)

  note = minor_key[step - 1]

  return note, octave
end

def text_converter (text_file_full_path)
  # Instrument 1
  # Get a book from the Gutenberg project
  book_filename = File.basename text_file_full_path
  current_root_path = File.expand_path(File.dirname(__FILE__))
  book_filepath = File.join(current_root_path, book_filename)

  # Get the title
  book_title, extension = book_filename.split('.')

  # Convert the characters to unicode character codes
  title_code = convert_to_character_code(book_title)
  title_key_index = (title_code.to_f/128*12).to_f.ceil

  notes = ['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
  root_index = title_key_index - 1
  puts 'ROOT NOTE'
  puts notes[root_index]

  # Get the text and parse each line
  text_code = []
  text_duration = []
  File.open(book_filename).each do |line|
    # Split on ending punctuation (periods, question marks, exclamation points)
    line.delete!("\n")
    sentences = line.split(/(?<=[?.!])/)
    # Parse each sentence into words
    sentences.each do |sentence|
      words = sentence.split(' ')
      # Convert words into unicode character codes
      words.each do |word|
        word_code = convert_to_character_code(word)
        # Put word codes into the code array
        text_code.push(word_code)
        # Put the word lengths into a duration array
        text_duration.push(word.length)
      end
      # Put a rest in at the end of each sentence
      text_code.push(0)
      text_duration.push(4)
    end
  end

  # Convert text tone to a note on the musical scale
  # To do this, scale the range by 28
  # (the number of notes in a maj/min scale across 4 octaves)
  text_tone = []
  text_code.each do |code|
    tone = (code.to_f/128*28).ceil
    text_tone.push(tone)
  end

  # Write notes to track
  File.open('rubysynth/instrumentation.rb', "w+") do |f|
    intro = "def input_data
      bpm = 120
      voice = Instrument.new(bpm, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, nil)

      leadTrack = Track.new(voice)"
    f.puts(intro)
    text_tone.each.with_index do |tone, index|
      note, octave = get_note_and_octave(tone, root_index)
      duration = text_duration[index]
      line = 'leadTrack.notes << Note.new("' +
                                              note + '",' +
                                              octave.to_s + ',' +
                                              duration.to_s + ')'
      f.puts(line)
    end
  ending = "s = Song.new()
  s.tracks = [leadTrack]

  return s.nextSamples(s.sampleLength)
  end"
  f.puts(ending)
  return book_title
  end
end

text_file_full_path = ARGV[0]
book_title = text_converter (text_file_full_path)
output_path = './' + book_title + '.wav'
generate_samples
create_wav_file(output_path)
