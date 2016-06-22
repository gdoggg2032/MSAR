% BT over a given wave/mp3 file
close all; clear all;

auFile='shortClip4bt\037.wav';
au=myAudioRead(auFile);

btOpt=myBtOptSet;
[cBeat, au]=myBt(au, btOpt, 1);
% ====== Play the song with computed beats
tempWaveFile=[tempname, '.wav']; tickAdd(au, cBeat, tempWaveFile); dos(['start ', tempWaveFile]);
% ====== Play the song with GT beats
fprintf('Hit return to hear the GT beats...\n'); pause; fprintf('\n');
tempWaveFile=[tempname, '.wav']; tickAdd(au, au.gtBeat{1}, tempWaveFile); dos(['start ', tempWaveFile]);