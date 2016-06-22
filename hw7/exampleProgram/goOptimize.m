% Wing ratio tuning for constant-tempo beat tracking

clear all; close all;

prmName='wingRatio'; prm=linspace(0.01, 0.2, 20);		% wingRatio
caseNum=length(prm);
perf=zeros(1, caseNum);
btOpt=myBtOptSet;
fprintf('Loading auSet.mat...\n');
load auSet.mat

for i=1:caseNum
	btOpt.(prmName)=prm(i);
	perf(i)=btPerfEval(auSet, btOpt);
	fprintf('%d/%d: %s=%f, F-measure=%f\n', i, caseNum, prmName, prm(i), perf(i));
end

[maxValue, maxIndex]=max(perf);
plot(prm, perf, '.-'); grid on
line(prm(maxIndex), maxValue, 'marker', 'o', 'color', 'r');
title(sprintf('Max f-measure=%f when %s=%f', maxValue, prmName, prm(maxIndex)));
xlabel(prmName);
ylabel('F-measure');