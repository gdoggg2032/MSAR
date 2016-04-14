function wave = note2wave01(pitch, duration, fs)
    wave = [];
    for i = 1:length(pitch)
        samples = duration(i) * fs;
        frequency = 2^((pitch(i)-69)/12) * 440;
        time = (0: duration(i)*fs-1)/fs;
        
        cut1 = floor(0.03*samples);
        cut2 = floor(0.97*samples);
        x = [linspace(0, 1, cut1), ones(1,cut2 - cut1), linspace(1, 0, samples - cut2)];
    
        %timex = time .* x;
        y = sin(2 * pi * frequency * time).* x;
        
        wave = [wave, y];
    end
end