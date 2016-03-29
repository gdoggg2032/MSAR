function epdOpt=myEpdOptSet
% myEpdOptSet: Returns the options (parameters) for EPD
epdOpt=endPointDetect('defaultOpt');
epdOpt.frameSize = 256;
epdOpt.overlap = 0;
epdOpt.volumeRatio = 0.1;
