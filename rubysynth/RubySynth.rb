require_relative 'Includes.rb'

def generate_samples
  require_relative 'instrumentation'
  startTime = Time.now
  #data = sineBeep()
  #data = DemoSong()
  #data = SweetChildOMine()
  #data = SweetDreams()
  #data = Metamorphosis()
  data = input_data()
  stopTime = Time.now

  puts "Total samples: " + data.length.to_s
  puts "Max sample: " + data.max.to_s
  puts "Min sample: " + data.min.to_s
  puts "Time to generate sample data: " + (stopTime - startTime).to_s + " seconds."
end

def create_wav_file (output_path)
  startTime = Time.now
  wave = WaveFile.new(1, 44100, 16)
  wave.sampleData = input_data()
  wave.save(output_path)
  stopTime = Time.now
  puts "Time to save wave file: " + (stopTime - startTime).to_s + " seconds."
end
