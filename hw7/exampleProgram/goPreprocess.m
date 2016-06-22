% Read audio files for BT

close all; clear all;

btOpt=myBtOptSet;
tempData=recursiveFileList(btOpt.auDir, 'wav');	% Collect all audio files
auNum=length(tempData);
% ====== Beat tracking
fprintf('Reading (and processing) %d audio files from "%s" for beat tracking...\n', auNum, btOpt.auDir);
for i=1:auNum
	fprintf('%d/%d: auFile=%s, ', i, auNum, tempData(i).name); myTic=tic;
	% ====== Read audio files
	au=myAudioRead(tempData(i).path);
	au.signal=mean(au.signal, 2);
	% ====== Read GT
	au.gtBeat=btGtRead(au.file);
	% ====== Preprocessing
	au.osc=wave2osc(au, btOpt.oscOpt);
	au.acf=frame2acf(au.osc.signal, length(au.osc.signal), btOpt.acfMethod);
%	au.tempogram=novelty2tempogram(au.osc, btOpt);				% Too big to store as a mat file!
%	au.tempoCurve=tempogram2tempoCurve(au.tempogram, btOpt);
%	au.cBeat=tempoCurve2beat(au.tempoCurve, au.osc, au.tempogram, btOpt);
	auSet(i)=au;
	fprintf('time=%g sec\n', toc(myTic));
end

% ====== Save the collect data
fprintf('Save auSet to auSet.mat...\n');
save auSet auSet