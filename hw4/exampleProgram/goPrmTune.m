% This is an example of exhaustive search to find the optimal parameter value for EPD

auDir='waveFile';
auDir='../2012-MSAR';
%auDir='/users/jang/temp/epdTrain';
fprintf('Reading wave files from "%s"...\n', auDir);
auSet=epdAuSetRead(auDir);

epdOpt=myEpdOptSet;


%volRatio1=linspace(0.07, 0.9, 5);
%volRatio2=linspace(eps, 0.5, 20);
volRatio2 = linspace(0.2, 0.6, 20);
recogRate=0*volRatio2;
%recogRate = 0 * volRatio1' * volRatio2;
for i=1:length(volRatio2)
        epdOpt.volRatio2 = volRatio2(i);
        recogRate(i) = epdPerfEval(auSet, epdOpt);
%         recogRate(i) = mean([epdPerfEval(auSet(1:floor(length(auSet)/5)), epdOpt), ...
%         epdPerfEval(auSet(floor(length(auSet)/5):floor(length(auSet)*2/5)), epdOpt), ...
%         epdPerfEval(auSet(floor(length(auSet)*2/5):floor(length(auSet)*3/5)), epdOpt), ...
%         epdPerfEval(auSet(floor(length(auSet)*3/5):floor(length(auSet)*4/5)), epdOpt), ...
%         epdPerfEval(auSet(floor(length(auSet)*4/5):floor(length(auSet)*5/5)), epdOpt)]);
    
	%epdOpt.volumeRatio=volumeRatio(i);
    
	
    
        fprintf('%d/%d: volRatio2 = %g, Recog. rate = %.2f%%.\n', i, length(volRatio2), epdOpt.volRatio2, recogRate(i)*100);
        %fprintf('%d/%d: Volume ratio = (%g, %g), Recog. rate = %.2f%%.\n', (i-1)*length(volRatio2) + j, length(volRatio1)*length(volRatio2), epdOpt.volRatio, epdOpt.volRatio2, recogRate(i,j)*100);
    
end

plot(volRatio1, recogRate*100, '.-');
[maxRecogRate, index]=max(recogRate);
fprintf('Best volume ratio = %g, best RR = %g%%\n', volRatio1(index), maxRecogRate*100);
line(volRatio1(index), maxRecogRate*100, 'color', 'r', 'marker', 'o');
xlabel('volumeRatio'); ylabel('Recog. Rate (%)');
