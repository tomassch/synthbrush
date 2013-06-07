clear all;
close all;

fs = 44100; %Hz
octaveSpan = 2; %Octave
freqRes = 10*12; %Freqs/Octave
n = 2; %Number of minFreq periods to be shown in a frame
fade = 1/25; %*100% of the matrix. How long is the fade-in/out between frames
            %larger fade times are better, causing less frequency drift
minFreq = 220; %Hz
geratemplate = 'template1.png';
inputImage = 'vai.png';
templateLength = 5; %second
templateBPM = 100; %beats per minute
frameOverSample = 24; %Frames/ImageColumn
volume = 0.8; % percent of full scale

overlap = fade/2;
timespan = n*fs/minFreq; %samples/frame

freqVector = minFreq*2.^transpose(fliplr([0:1/freqRes:octaveSpan])); %Hz
freqVector = 2*pi*freqVector; %rad/s

%Read the input image
%must be done before the template writting
inIm = imread(inputImage);

%Generate a template to make things easier later
%In the future this must be in a different file!
if ~strcmp(geratemplate,'') %if template name is not empty
   %black image with green guides
   im(:,:,1) = zeros(length(freqVector),50);%templateLength*timespan/frameOverSample);
   im(:,:,2) = im(:,:,1);
   im(:,:,3) = im(:,:,1);
   %weak green line for each tone
   im([1:freqRes/12:octaveSpan*freqRes],:,2) = 0.2;
   %bold green line in every "A"   
   im([1:freqRes:octaveSpan*freqRes],:,2) = 1;   
   imwrite(im,geratemplate);
end

%time line
timeVector = [1/fs:1/fs:n/minFreq]; %s


%fade line (trapezium)
fadeVector = ones(size(timeVector));
fadeSpan = round(fade*length(timeVector));
ramp = [0:1/fadeSpan:1];
%ramp up
fadeVector(1,1:length(ramp))=ramp;
%ramp down
fadeVector(1,(end-length(ramp)+1):end)=fliplr(ramp);


%rad matrix (rectangular matrix)
freqMatrix = freqVector * timeVector; %rad
%apply sin to get volts from rads
freqMatrix = sin(freqMatrix); %"volts"
%trapezoidal fading (very simple)
fadeMatrix = ones(length(freqVector),1)*fadeVector;
%apply fading
freqMatrix = freqMatrix .* fadeMatrix;
clear fadeMatrix;



%process left channel (R)

%allocate time buffer
Rout = zeros(1,250*templateLength*fs);
current=1;
for i=[1:1:size(inIm,2)]
   %this is the key line. Frequencies from the image are being
   %multiplied by the volt samples in time 
   timeSeg = double(transpose(inIm(:,i,1)))*freqMatrix;
   if i==1
    plot(timeSeg)
   end
   %trail all time segments together, overlaping the fade
   for j=[1:1:frameOverSample]
      Rout(1,current:current+length(timeSeg)-1) = ...
         Rout(1,current:current+length(timeSeg)-1) + ...
         timeSeg;
      current = current+(length(timeSeg)*(1-fade));
   end
end

%Normalize
Rout = 0.8*Rout/max(max(Rout));

wavwrite('output.wav',Rout',44100);
