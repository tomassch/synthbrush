%Parameter container for all functions
%This should be called by vai.m and genTemplate.m
%I put it here to avoid repeating the definitions

%---------- user setup space --------------
fs = 44100; %Hz, Sampling frequency

freqRes = 10*12; %Freqs/Octave, number of frequencies in each octave (multiple of 12 for equal temperament)
minFreq = 27.5; %Hz frequency at the bottom, the lowest frequency

imageColumnPerSecond = 50; %ImageColumn/second
volume = 0.8; % percent of full scale
%---------- end of user setup space --------------

%---------- derivation space (devs) --------------



%---------- end of derivation space --------------
