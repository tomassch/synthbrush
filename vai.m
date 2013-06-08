%TODO, recompile GraphicsMagick to get more bits per pixel in images
% see http://wiki.octave.org/GraphicsMagick
%AND THEN, rebuild octave (a.k.a major pain in the bum)

clear all;
close all;

%--------- Local Parameters -------------------------
inputImage = 'template1.png';
%----------------------------------------------------

parameters; %set up the parameters (see parameters.m)

%Read the input image
inIm = imread(inputImage);

%derive stuff from image
octaveSpan = size(inIm,1)/freqRes;
%limited to whole octave files
%TODO flexibilize this:
% boils down to rethink the freqVector generation
if mod(octaveSpan,1)~=0
   error('Image must have whole octaves');
end

duration = (size(inIm,2)-1)/imageColumnPerSecond; %seconds

freqVector = minFreq ...
             *2.^(transpose(fliplr([0:1/freqRes:octaveSpan]))); %Hz
freqVector = 2*pi*freqVector; %rad/s

%time line
timeVector = [1/fs:1/fs:duration]; %seconds, really long vector
Rout = zeros(size(timeVector));
%upsampling factor
upsamplingFactor = fs/imageColumnPerSecond; %Samples per ImageColumn
%TODO flexibilize this, boils down to making a proper upsample algorithm
%(i.e. one that can upsample by non integer factors)
if mod(upsamplingFactor,1)~=0
   error('Fs must be a multiple of image column per second');
end


%%lazy algorithm (a.k.a I skiped my DSP classes and forgot how to window an FFT)
%%complexity O(n*m) n time; m freq
%for each line of the image
  % upsample the line from image time resolution to sound time resolution
  %interpolate the upsampled line, thus getting an envelope
  % multiply the envelope with the corresponding sinewave
      %tip: randomize the inital phase of each frequency to avoid the dirac
  % acumulate the result in the final audio vector
%end for
for m=[1:1:length(freqVector)-1]%WOP -1
  imageLine = double(inIm(m,:,1));%WOP, only getting the right channel!!!
  envelope = real(interp1(imageLine,[1:1/upsamplingFactor:length(imageLine)]));
  envelope = envelope(2:end);
  %make a sine vector the same size of the time vector
  %at frequency m
  %with a random initial phase (to spread the noise energy along time) 
  sineVector = sin(2*pi*rand+ ... %random phase
                   freqVector(m)*timeVector); %could be simplified but not critical
  %the important line
  Rout = Rout + (sineVector.*envelope);
end

%%Normalize
mRout = max(max(Rout));
if (mRout~=0) %avoid indian bread, thanks to andrekw
    %TODO convert volume to dB
    Rout = volume*Rout/max(max(Rout));
else
    disp('Image seems to contain no sound (max amplitude=0)');
end

%Save output to disk in audible format
wavwrite(Rout',44100,'output.wav');
