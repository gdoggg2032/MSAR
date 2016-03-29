function [epInSampleIndex, epInFrameIndex] = myEpd(au, epdOpt, showPlot)
% myEpd: a simple example of EPD
%
%	Usage:
%		[epInSampleIndex, epInFrameIndex] = endPointDetect(au, showPlot, epdOpt)
%			epInSampleIndex: two-element end-points in sample index
%			epInFrameIndex: two-element end-points in frame index
%			au: input wave object
%			epdOpt: parameters for EPD
%			showPlot: 0 for silence operation, 1 for plotting
%
%	Example:
%		waveFile='SingaporeIsAFinePlace.wav';
%		au=waveFile2obj(waveFile);
%		epdOpt=myEpdOptSet;
%		showPlot = 1;
%		out = myEpd(au, epdOpt, showPlot);

%	Roger Jang, 20040413, 20070320, 20130329

if nargin<1, selfdemo; return; end
if nargin<2, epdOpt=myEpdOptSet; end
if nargin<3, showPlot=0; end

wave=au.signal; fs=au.fs;
frameSize=epdOpt.frameSize; overlap=epdOpt.overlap;
wave=double(wave);				% convert to double data type (�ন��ƫ��A�O double ���ܼ�)
wave=wave-mean(wave);				% zero-mean substraction (�s�I�ե�)
frameMat=enframe(wave, frameSize, overlap);	% frame blocking (���X����)
frameNum=size(frameMat, 2);			% no. of frames (���ت��Ӽ�)
volume=frame2volume(frameMat);			% compute volume (�p�⭵�q)
volumeTh=max(volume)*epdOpt.volumeRatio;	% compute volume threshold (�p�⭵�q���e��)
index=find(volume>=volumeTh);			% find frames with volume larger than the threshold (��X�W�L���q���e�Ȫ�����)
epInFrameIndex=[index(1), index(end)];
epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);	% conversion from frame index to sample index (�� frame index �ন sample index)

%addition
[epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, others] = endPointDetect(au, epdOpt, showPlot);


if showPlot,
	subplot(2,1,1);
	time=(1:length(wave))/fs;
	plot(time, wave); axis tight;
	line(time(epInSampleIndex(1))*[1 1], [min(wave), max(wave)], 'color', 'g');
	line(time(epInSampleIndex(end))*[1 1], [min(wave), max(wave)], 'color', 'm');
	ylabel('Amplitude'); title('Waveform');

	subplot(2,1,2);
	frameTime=((1:frameNum)-1)*(frameSize-overlap)+frameSize/2;
	plot(frameTime, volume, '.-'); axis tight;
	line([min(frameTime), max(frameTime)], volumeTh*[1 1], 'color', 'r');
	line(frameTime(index(1))*[1 1], [0, max(volume)], 'color', 'g');
	line(frameTime(index(end))*[1 1], [0, max(volume)], 'color', 'm');
	ylabel('Sum of abs.'); title('Volume');
	
	U.wave=wave; U.fs=fs;
	if ~isempty(epInSampleIndex)
		U.voicedY=U.wave(epInSampleIndex(1):epInSampleIndex(end));
	else
		U.voicedY=[];
	end
	set(gcf, 'userData', U);
	uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.wave, U.fs);', 'position', [20, 20, 100, 20]);
	uicontrol('string', 'Play detected', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY, U.fs);', 'position', [150, 20, 100, 20]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
