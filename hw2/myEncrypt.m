function yOut = myEncrypt(inputFileName, outputFileName)
    [yIn, fs] = audioread(inputFileName);
    InfoIn = audioinfo(inputFileName);
    %bitpersample
    
    yOut = yIn;
    for i = 1 : length(yOut)
        if yIn(i) > 0
            yOut(i) = 1 - yIn(i);
        end
        if yIn(i) < 0
            yOut(i) = -1 - yIn(i);
        end
    end
        
    %yOut = sign(yIn) - yIn;
    yOut = flipud(yOut);
    
    audiowrite(outputFileName, yOut, fs, 'BitsPerSample', InfoIn.BitsPerSample);
end