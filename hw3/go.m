wavFile = 'lowPitch.wav';
y = audioread(wavFile);
info = audioinfo(wavFile);
fs = info.SampleRate;

index1=11050;
frameSize=512;
index2=index1+frameSize-1;
frame=y(index1:index2);

subplot(4, 1, 1); plot(y); grid on
title(wavFile);
line(index1*[1 1], [-1 1], 'color', 'r');
line(index2*[1 1], [-1 1], 'color', 'r');
subplot(4,1,2); plot(frame, '.-'); grid on
point=[65, 448];
line(point, frame(point), 'marker', 'o', 'color', 'red');

periodCount=5;
fp=((point(2)-point(1))/periodCount)/fs;	% fundamental period
ff=fs/((point(2)-point(1))/periodCount);	% fundamental frequency
pitch=69+12*log2(ff/440);
pitch1 = pitch;
fprintf('--------------lowPitch------------\n');
fprintf('Fundamental period = %g second\n', fp);
fprintf('Fundamental frequency = %g Hertz\n', ff);
fprintf('Pitch = %g semitone\n', pitch);
fprintf('Keyboard: G#2\n');


wavFile = 'highPitch.wav';
y = audioread(wavFile);
info = audioinfo(wavFile);
fs = info.SampleRate;

index1=11050;
frameSize=512;
index2=index1+frameSize-1;
frame=y(index1:index2);

subplot(4,1,3); plot(y); grid on
title(wavFile);
line(index1*[1 1], [-1 1], 'color', 'r');
line(index2*[1 1], [-1 1], 'color', 'r');
subplot(4,1,4); plot(frame, '.-'); grid on
point=[124, 299];
line(point, frame(point), 'marker', 'o', 'color', 'red');

periodCount=16;
fp=((point(2)-point(1))/periodCount)/fs;	% fundamental period
ff=fs/((point(2)-point(1))/periodCount);	% fundamental frequency
pitch=69+12*log2(ff/440);
pitch2 = pitch;
fprintf('----------highPitch---------------\n');
fprintf('Fundamental period = %g second\n', fp);
fprintf('Fundamental frequency = %g Hertz\n', ff);
fprintf('Pitch = %g semitone\n', pitch);
fprintf('Keyboard: F#5\n');

fprintf('-----------result-----------------\n');
fprintf('Pitch ragne = %g ~ %g (semitone)\n', pitch1, pitch2);
fprintf('Pitch range in keyboard: G#2 ~ F#5\n');


