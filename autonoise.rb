# Use rubysynth for tone generation and sequencing
require_relative 'rubysynth/RubySynth'
require_relative 'text_noise.rb'
require 'yaml'

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

def write_track (input_data, text_tone, text_duration)
  # Write notes to track
  input = input_data[0]
  birth_year = input['author birth year']
  death_year = input['author death year']
  bpm = death_year - birth_year
  freq = input['location long']
  amp = input['location lat']/90

  File.open('rubysynth/instrumentation.rb', "w+") do |f|
    intro = "def input_data
      bpm = " + bpm.to_s + "
      voice = Instrument.new(bpm, SquareOscillator.new(44100, " + freq.to_s + ", " + amp.to_s + "), [], nil, nil)

      leadTrack = Track.new(voice)"
    f.puts(intro)
    text_tone.each.with_index do |tone, index|
      if tone == nil
        note = ''
        octave = 0
      else
        note, octave = get_note_and_octave(tone, root_index)
      end
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
  end
end

input_file = ARGV[0]
input = YAML.load_file(input_file)

text_tone, text_duration = text_converter (input)

output_path = './' + input['title'] + '.wav'
generate_samples
create_wav_file(output_path)
