%in the future this should be made into a function to make variable scope local

%----------- Local Parameters -------------------------
geratemplate = 'toInkscape.png';

templateLength = 10; %seconds

templateBPM = 120; %beats per minute
rythmDiv = 4; %quaternary? ternary? 
              %this is the numerator of the rhytm fraction 
              %usually found at the begining of music scores

octaveSpan = 9; %octaves
%------------------------------------------------------

%------------- Template parameters --------------------
weak = 0.2;
bold = 1;
%-----------------------------------------------------

parameters; %set up the common parameters (fs and stuff, see parameters.m)

%Generate a template to make things easier later
%In the future this must be in a different file!
if ~strcmp(geratemplate,'') %if template name is not empty
   %black image with green guides
   im(:,:,1) = zeros( octaveSpan ...
                     *freqRes, ... 
                      templateLength ...
                     *imageColumnPerSecond);
   im(:,:,2) = im(:,:,1);
   im(:,:,3) = im(:,:,1);
   %weak green line for each tone
   im([1:freqRes/12:octaveSpan*freqRes],:,2) = weak;
   %bold green line in every "A"   
   im([1:freqRes:octaveSpan*freqRes],:,2) = bold;   
   %weak green line for every beat
   im(:,[1:imageColumnPerSecond*60/templateBPM:end],2)=weak;
   %bold green line for every beat
   im(:,[1:rythmDiv*imageColumnPerSecond*60/templateBPM:end],2)=bold;
   imwrite(im,geratemplate);
   clear im;
end

%emulate locality
clear octaveSpan; %should be derived elsewhere
