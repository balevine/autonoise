def input_data
      bpm = 120
      voice = Instrument.new(bpm, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, nil)

      leadTrack = Track.new(voice)
leadTrack.notes << Note.new("A",2,4)
leadTrack.notes << Note.new("C",2,2)
leadTrack.notes << Note.new("G",2,1)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A#",2,2)
leadTrack.notes << Note.new("G",2,5)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("A",2,4)
leadTrack.notes << Note.new("C",2,2)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("G",2,1)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A#",2,2)
leadTrack.notes << Note.new("G",2,5)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("F",2,2)
leadTrack.notes << Note.new("A#",2,3)
leadTrack.notes << Note.new("D",2,3)
leadTrack.notes << Note.new("A",2,10)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("A",2,4)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A#",2,2)
leadTrack.notes << Note.new("C",2,4)
leadTrack.notes << Note.new("A#",2,3)
leadTrack.notes << Note.new("A",2,2)
leadTrack.notes << Note.new("A#",2,10)
leadTrack.notes << Note.new("A#",2,8)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("C",2,9)
leadTrack.notes << Note.new("C",2,2)
leadTrack.notes << Note.new("A#",2,3)
leadTrack.notes << Note.new("C",2,4)
leadTrack.notes << Note.new("F",2,5)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("A",2,4)
leadTrack.notes << Note.new("C",2,2)
leadTrack.notes << Note.new("C",2,3)
leadTrack.notes << Note.new("C",2,7)
leadTrack.notes << Note.new("F",-1,4)
s = Song.new()
  s.tracks = [leadTrack]

  return s.nextSamples(s.sampleLength)
  end
