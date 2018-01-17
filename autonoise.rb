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

def write_track (input_data, text_tone, text_duration, root_index)
  # Write notes to track

  File.open('rubysynth/instrumentation.rb', "w+") do |f|
    setup_text = instr_setup_text (input_data)
    f.puts(setup_text)

    intro = "leadTrack = Track.new(voice)"
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

text_tone, text_duration, root_index = text_converter (input)
write_track(input, text_tone, text_duration, root_index)
# Get total beat durations
beats = 0
text_duration.each do |dur|
  beats = beats + (1/dur.to_f)
end

song_beats = beats.ceil

output_path = './' + input['title'] + '.wav'

# generate_samples
# create_wav_file(output_path)
