function btOpt=btOptSet

% addpath /Applications/MATLAB_R2015b.app/toolbox/utility
% addpath /Applications/MATLAB_R2015b.app/toolbox/machineLearning
% addpath /Applications/MATLAB_R2015b.app/toolbox/sap

btOpt.auDir='shortClip4bt';
btOpt.wingRatio=0.08;		% One-side tolerance for beat position identification via forward/forward search (only for constant tempo)
btOpt.bpmMax=250;
btOpt.bpmMin=100;		% 70
btOpt.trialNum=8;		% No. of trials for beat positions
btOpt.acfMethod=2;		% Method for computing OSC's ACF
btOpt.useDoubleBeatConvert=1;	% Double beat conversion: Convert to double beat if necessary
btOpt.useTripleBeatConvert=0;	% Triple beat conversion: Convert to double beat if necessary
btOpt.peakHeightTol=0.1;	% If two peaks are different by 10% with multiple BPM, small BPM is selected.
btOpt.oscOpt=wave2osc('defaultOpt');	% Options for onset strength curve
%btOpt.oscOpt.useMelFreq=1;
% === Do not change the following two lines
btOpt.btFcn='myBt';		% Main function for beat tracking
btOpt.type='constant';		% 'constant' or 'time-varying' tempo
btOpt.tolerance=0.07;		% For computing F-measure