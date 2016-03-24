[y, fs] = audioread('myVoice.wav');
yLeft = y;
yRight = y;

w = 3;
transLeft = sin((1/w)*pi*(1:length(y))/fs);
transRight = cos((1/w)*pi*(1:length(y))/fs);

vLeft = yLeft .* transLeft';
vRight = yRight .* transRight';

yStereo = [vLeft, vRight];

sound(yStereo);

