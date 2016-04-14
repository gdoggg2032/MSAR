function epdOpt=myEpdOptSet
% myEpdOptSet: Returns the options (parameters) for EPD
% epdOpt=endPointDetect('defaultOpt');
epdOpt.frameSize = 256;
epdOpt.overlap = 64;
% % %epdOpt.volumeRatio = 0.0979592;
% % epdOpt.volRatio = 0.0789474; 
% % epdOpt.method='vol';
% 
% % volHoc
% epdOpt.method='volHod';


% epdByVolZcr
epdOpt.minSegment = 0.0789474;%f
epdOpt.maxSilBetweenSegment = 0.4160; %f
epdOpt.vMinMaxPercentile = 3;
epdOpt.volRatio = 0.0789474; %f
epdOpt.volRatio2 = 0.2; %d
epdOpt.zcrShiftGain = 4; 
epdOpt.zcrRatio = 0.184211; %f