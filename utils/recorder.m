function recorder(outputname, duration)
    r = audiorecorder();
    r.recordblocking(duration);
    audiowrite(outputname, r.getaudiodata(), r.SampleRate);
end
