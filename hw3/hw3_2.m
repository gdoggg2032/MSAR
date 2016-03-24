pitch=   [55 55 55 55 57 55 0 57 60 0  64 0  62 62 62 62 60 64 60 0 57 55 55];
duration=[23 23 23 23 23 35 9 23 69 18 69 18 23 23 23 12 12 23 35 9 12 12 127]/64;
fs=16000;
wave=note2wave01(pitch, duration, fs);
sound(wave, fs);