%in the future this should be made into a function to make variable scope local

%----------- Local Parameters -------------------------
geratemplate = 'template1.png';

templateLength = 10; %seconds

templateBPM = 100; %beats per minute (vertical green bars, TODO)

octaveSpan = 2; %octaves
%------------------------------------------------------

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
   im([1:freqRes/12:octaveSpan*freqRes],:,2) = 0.2;
   %bold green line in every "A"   
   im([1:freqRes:octaveSpan*freqRes],:,2) = 1;   
   imwrite(im,geratemplate);
   clear im;
end

%emulate locality
clear octaveSpan; %should be derived elsewhere