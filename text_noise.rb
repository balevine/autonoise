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

def text_converter (input)
  # Instrument 1
  # Get a book from the Gutenberg project
  book_filename = File.basename input['text file']
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
  File.open(book_filename) do |file|
    text = file.read
    # Split on ending punctuation (periods, question marks, exclamation points)
    sentences = text.split(/(?<=[?.!])/)
    # Convert sentences to codes
    sentences.each do |sentence|
        word_code = convert_to_character_code(sentence)
        # Put codes into the code array
        text_code.push(word_code)
        # Put the sentence lengths into a duration array
        text_duration.push(sentence.length)
    end
  end

  # Convert text tone to a note on the musical scale
  # To do this, scale the range by 21
  # (the number of notes in a maj/min scale across 3 octaves)
  text_tone = []
  text_code.each do |code|
    if code == 0
      text_tone.push(nil)
    else
      tone = (code.to_f/128*21).ceil
      text_tone.push(tone)
    end
  end

  return text_tone, text_duration
end
