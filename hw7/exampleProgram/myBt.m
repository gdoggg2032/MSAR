function [cBeat, au]=myBt(au, btOpt, showPlot)
%myBt: Track beat
%
%	Usage:
%		cBeat=myBt(au, btOpt, showPlot)
%
%	Example:
%		waveFile='song01s5.wav';
%		au=waveFile2obj(waveFile);
%		btOpt=myBtOptSet;
%		showPlot=1;			% 1 for plotting intermdiate results, 0 for not plotting
%		cBeat=myBt(au, btOpt, showPlot);
%		tempWaveFile=[tempname, '.wav'];
%		tickAdd(au, cBeat, tempWaveFile);
%		dos(['start ', tempWaveFile]);

%	Roger Jang, 20120410

if nargin<1, selfdemo; return; end
if nargin<2, btOpt=btOptSet; end
if nargin<3, showPlot=0; end

if isstr(au), au=myAudioRead(au); end
au.signal=mean(au.signal, 2);	% Stereo ==> Mono
% ====== Read GT beat positions (if the GT file exists)
if ~isfield(au, 'gtBeat')
	au.gtBeat=btGtRead(au.file);
end
if ~isfield(au, 'osc')
	au.osc=wave2osc(au, btOpt.oscOpt, showPlot);	% Return the onset strength curve (novelty curve)
end

switch(btOpt.type)
	case 'time-varying'
		error('This is not allowed!');
	case 'constant'
		frame=au.osc.signal;
		%frame=frame-mean(frame);
		if ~isfield(au, 'acf'), au.acf=frame2acf(au.osc.signal, length(au.osc.signal), btOpt.acfMethod); end
		timeStep=au.osc.time(2)-au.osc.time(1);
		n1=round(60/btOpt.bpmMax/timeStep)+1;
		n2=round(60/btOpt.bpmMin/timeStep)+1;
		acf2=au.acf;
		acf2(1:n1)=-inf;
		acf2(n2:end)=-inf;
		[maxFirst, bp]=max(acf2);	% First maximum
		if btOpt.useDoubleBeatConvert
			factor=2;
			indexCenter=round((bp-1)/factor+1);
			sideSpread=round((indexCenter-1)*0.1);
			left=indexCenter-sideSpread; if left<1; left=1; end
			right=indexCenter+sideSpread; if right>length(au.acf), right=length(au.acf); end
			[maxInRange, bpLocal]=max(acf2(left:right));
			if (maxFirst-maxInRange)/maxFirst<btOpt.peakHeightTol
				bp=bpLocal+left-1;
			end
		end
		if btOpt.useTripleBeatConvert
			factor=3;
			indexCenter=round((bp-1)/factor+1);
			sideSpread=round((indexCenter-1)*0.1);
			left=indexCenter-sideSpread; if left<1; left=1; end
			right=indexCenter+sideSpread; if right>length(au.acf), right=length(au.acf); end
			[maxInRange, bpLocal]=max(acf2(left:right));
			if (maxFirst-maxInRange)/maxFirst<btOpt.peakHeightTol
				bp=bpLocal+left-1;
			end
		end
		bp=bp-1;	% Beat period
		bpm=60/(bp*timeStep);
		tempoCurve=bpm;		% For constant tempo, tempoCurve is only a single value of BPM.
		opt.trialNum=btOpt.trialNum;
		opt.wingRatio=btOpt.wingRatio;
		cBeatSet=periodicMarkId(frame, bp, opt, showPlot);
		[~, maxIndex]=max([cBeatSet.weight]);
		beatPos=cBeatSet(maxIndex).position;
		cBeat=beatPos*timeStep;
		globalMaxIndex=cBeatSet(maxIndex).globalMaxIndex;
		if showPlot
			figure
			subplot(311);
			frameSize=round(31.25/1000*au.fs);
			overlap=0;
			[y,f,t,p] = spectrogram(au.signal,256,0,1024);
			surf(t,f,10*log10(abs(p)),'EdgeColor','none');   
			axis xy; axis tight; colormap(jet); view(0,90);
			xlabel('Time');
			ylabel('Frequency (Hz)');
			subplot(312); plot(frame); set(gca, 'xlim', [-inf inf]);
			line(globalMaxIndex, frame(globalMaxIndex), 'marker', 'square', 'color', 'k');
			line(beatPos, frame(beatPos), 'marker', '.', 'color', 'm', 'linestyle', 'none');
			if isfield(au, 'gtBeat')		% Plot the GT beat
				gtBeat=au.gtBeat{1};
				axisLimit=axis;
				for i=1:length(gtBeat)
					line(gtBeat(i)/timeStep*[1 1], axisLimit(3:4), 'color', 'r'); 
				end
			end
			title('Novelty curve with computed beat positions');
			subplot(313); plot(au.acf); set(gca, 'xlim', [-inf inf]);
			axisLimit=axis;
			line(n1*[1 1], axisLimit(3:4), 'color', 'r');
			line(n2*[1 1], axisLimit(3:4), 'color', 'r');
			line(bp+1, au.acf(bp+1), 'marker', 'square', 'color', 'k');
			title('Auto-correlation of the novelty curve');
		end
end

fMeasure=[];
if isfield(au, 'gtBeat')
	for i=1:length(au.gtBeat)
		fMeasure(i)=simSequence(cBeat, au.gtBeat{i}, 0.07);
	end
	if showPlot
	%	figure; plot(fMeasure, 'o-'); xlabel('GT index'); ylabel('F-measure'); title('F-measure'); grid on
	%	set(gca, 'ylim', [0 1]);
	end
%	fprintf('F-measures=%s\n', mat2str(fMeasure, 2));
%	fprintf('Mean F-measure=%.2f\n', mean(fMeasure));
	% === Playback to show the beats
%	fprintf('Playback to show the beats...\n');
%	outWave=beepCreate(cBeat, au.fs, au.signal);
%	sound(outWave, au.fs);
end

% Assign everything to au
au.cBeatSet=cBeatSet;
au.fMeasure=fMeasure;
au.cBeat=cBeat;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
