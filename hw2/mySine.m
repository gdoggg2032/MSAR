function outputSignal = mySine(duration, freq)

    fs = 16000;
    time = (0:(duration*fs-1))/fs;
    f1 = freq(1);
    f2 = freq(2);
    
    slope = (f2 - f1)/time(length(time));
    
    %outputSignal = sin( 2 * pi * ( (f2 - f1)/(duration) * time + f1) .* time);
    outputSignal = sin(2 * pi * (slope/2*time + f1) .* time);
end

