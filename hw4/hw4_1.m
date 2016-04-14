fprintf('--------the fastest clap------\n');
wavFile = 'fastestClap.wav';
y = audioread(wavFile); 
y = y(:, 1); % we only use the left channel
info = audioinfo(wavFile);
fs = info.SampleRate;

frameSize = 512;
overlap = 256;

frameRate = fs / (frameSize - overlap);
framePerSecond = ceil(frameRate);

frameMat = enframe(y, frameSize, overlap);
frameNum = size(frameMat, 2);

volume=zeros(frameNum, 1);
for i = 1 : frameNum
	frame = frameMat(:, i);
	frame = frame - median(frame);		% zero-justified
	volume(i) = sum(abs(frame));             % method 1
    
    
end

volume = 100/max(volume) * volume; % normalize

[sortedVol, sortingIndices] = sort(volume, 'descend');
low = sortedVol(floor(frameNum/100 * 97));
high = sortedVol(ceil(frameNum/100 * 3));

maxCount = 0;

% for each second, count the peaks
for i = 1 : frameNum - framePerSecond
    volumeSecond = volume(i : i + framePerSecond);
    %     for vol = floor(max(volumeSecond)):-1:0
    %         vols = volumeSecond - vol;
    %         zeroCount = sum(abs(diff(sign(vols))/2));
    %         count = zeroCount / 2;
    %         if count >= 14
    %             break;
    %         end
    %     end
    [sortedVol, sortingIndices] = sort(volumeSecond, 'descend');
    
    % vol = (max(volumeSecond)+ min(volumeSecond))/2;
%     low = sortedVol(floor(framePerSecond/100 * 97));
%     high = sortedVol(ceil(framePerSecond/100 * 3));
    vol = 0.5 * (high - low) + low;
    % vol = 0.9 * median(volumeSecond);
    if vol < mean(volume)
        continue;
    end
    vols = volumeSecond - vol;
   
    zeroCount = sum(abs(diff(sign(vols))/2));
    count = floor(zeroCount / 2);
    if maxCount < count
        fprintf('find a new peak: %d, count: %d\n', i, count);
        frame14head = i;
        vol14 = vol;
        maxCount = count;
        %break;
    end
    count = -1;
    
end



sampleTime = (1 : length(y)) / fs;
frameTime = ((0 : frameNum - 1) * (frameSize - overlap) + 0.5 * frameSize) / fs;
subplot(4, 1, 1); plot(frameTime, volume, '.-');line(frameTime(frame14head)*[1 1], [0 100], 'color', 'r', 'LineWidth', 2); ylabel(wavFile);
subplot(4, 1, 2); plot(frameTime(frame14head : frame14head + framePerSecond), volume(frame14head : frame14head + framePerSecond), '.-'); ylabel('Volume'); xlabel('Time (sec)');
fprintf('The peak performane, %d claps per second, happens at %g.\n', maxCount, frameTime(frame14head));
line(frameTime(frame14head)*[1 1], [0 100], 'color', 'r');
line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [vol14, vol14], 'Color', 'g', 'LineWidth', 2);
%line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [low, low], 'Color', 'g', 'LineWidth', 2);
%line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [high, high], 'Color', 'g', 'LineWidth', 2);

% line(index2*[1 1], [-1 1], 'color', 'r');
fprintf('---------my fastest clap------\n');

wavFile = 'myClap.wav';
y = audioread(wavFile); 
y = y(:, 1); % we only use the left channel
info = audioinfo(wavFile);
fs = info.SampleRate;

frameSize = 512;
overlap = 256;

frameRate = fs / (frameSize - overlap);
framePerSecond = ceil(frameRate);

frameMat = enframe(y, frameSize, overlap);
frameNum = size(frameMat, 2);

volume=zeros(frameNum, 1);
for i = 1 : frameNum
	frame = frameMat(:, i);
	frame = frame - median(frame);		% zero-justified
	volume(i) = sum(abs(frame));             % method 1
    
    
end
volume = 100/max(volume) * volume;
[sortedVol, sortingIndices] = sort(volume, 'descend');
low = sortedVol(floor(frameNum/100 * 97));
high = sortedVol(ceil(frameNum/100 * 3));

maxCount = 0;

% for each second, count the peaks
for i = 1 : frameNum - framePerSecond
    volumeSecond = volume(i : i + framePerSecond);
    %     for vol = floor(max(volumeSecond)):-1:0
    %         vols = volumeSecond - vol;
    %         zeroCount = sum(abs(diff(sign(vols))/2));
    %         count = zeroCount / 2;
    %         if count >= 14
    %             break;
    %         end
    %     end
    [sortedVol, sortingIndices] = sort(volumeSecond, 'descend');
    
    % vol = (max(volumeSecond)+ min(volumeSecond))/2;
%     low = sortedVol(floor(framePerSecond/100 * 97));
%     high = sortedVol(ceil(framePerSecond/100 * 3));
    vol = 0.35 * (high - low) + low;
    % vol = 0.9 * median(volumeSecond);
    if vol < mean(volume)
        continue;
    end
    vols = volumeSecond - vol;
   
    zeroCount = sum(abs(diff(sign(vols))/2));
    count = floor(zeroCount / 2);
    if maxCount < count
        fprintf('find a new peak: %d, count: %d\n', i, count);
        frame14head = i;
        vol14 = vol;
        maxCount = count;
        %break;
    end
    count = -1;
    
end



sampleTime = (1 : length(y)) / fs;
frameTime = ((0 : frameNum - 1) * (frameSize - overlap) + 0.5 * frameSize) / fs;
subplot(4, 1, 3); plot(frameTime, volume, '.-');line(frameTime(frame14head)*[1 1], [0 100], 'color', 'r', 'LineWidth', 2); ylabel(wavFile);
subplot(4, 1, 4); plot(frameTime(frame14head : frame14head + framePerSecond), volume(frame14head : frame14head + framePerSecond), '.-'); ylabel('Volume'); xlabel('Time (sec)');
fprintf('The peak performane, %d claps per second, happens at %g.\n', maxCount, frameTime(frame14head));
line(frameTime(frame14head)*[1 1], [0 100], 'color', 'r');
line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [vol14, vol14], 'Color', 'g', 'LineWidth', 2);
%line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [low, low], 'Color', 'g', 'LineWidth', 2);
%line([frameTime(frame14head), frameTime(frame14head + framePerSecond)], [high, high], 'Color', 'g', 'LineWidth', 2);

% line(index2*[1 1], [-1 1], 'color', 'r');

