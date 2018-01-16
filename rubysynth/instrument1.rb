def Metamorphosis
    bpm = 120
    lead = Instrument.new(bpm, SawtoothOscillator.new(44100, 110.0, 0.5), [1.0], NoiseOscillator.new(44100, 220.0, 3.0), nil)

    leadTrack = Track.new(lead)
leadTrack.notes << Note.new("A",1,1)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("G",2,3)
leadTrack.notes << Note.new("A",2,8)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A",2,6)
leadTrack.notes << Note.new("A",1,1)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("G",2,3)
leadTrack.notes << Note.new("A",2,8)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A",2,6)
leadTrack.notes << Note.new("A",1,1)
leadTrack.notes << Note.new("F",-1,4)
leadTrack.notes << Note.new("G",2,3)
leadTrack.notes << Note.new("A",2,8)
leadTrack.notes << Note.new("A#",2,4)
leadTrack.notes << Note.new("A",2,6)
s = Song.new()
s.tracks = [leadTrack]

return s.nextSamples(s.sampleLength)
end
