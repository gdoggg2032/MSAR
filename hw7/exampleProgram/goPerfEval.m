% Performance evaluation for beat tracking

close all; clear all;
btOpt=myBtOptSet;
btOpt.wingRatio=0.14;	% Overwrite the default parameters

load auSet
auNum=length(auSet);
[perf, auSet]=btPerfEval(auSet, btOpt);
[sortedValue, sortedIndex]=sort([auSet.meanFMeasure]);
for i=1:auNum
	index=sortedIndex(i);
	fprintf('%d/%d: audioFile=%s, F-measure=%.2f\n', i, auNum, auSet(index).file, auSet(index).meanFMeasure);
end
fprintf('Mean F-measure=%f\n', perf);

% === Plot the beat time for each file
for i=1:auNum
	index=sortedIndex(i);
	clf; simSequence(auSet(index).cBeat, auSet(index).gtBeat{1}, btOpt.tolerance, 1);
	title(strPurify(auSet(index).file));
	fprintf('%d/%d: audioFile=%s, F-measure=%.2f, invalidCount=%d\n', i, auNum, auSet(index).file, auSet(index).meanFMeasure, auSet(index).invalidCount);
	fprintf('Press any key to contiune...'); pause; fprintf('\n');
end
