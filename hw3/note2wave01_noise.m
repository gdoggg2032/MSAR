function wave = note2wave01_noise(pitch, duration, fs)
    wave = [];
    for i = 1:length(pitch)
        samples = duration(i) * fs;
        frequency = 2^((pitch(i)-69)/12) * 440;
        time = (0: duration(i)*fs-1)/fs;
        y = sin(2 * pi * frequency * time);
        wave = [wave, y];
    end
end