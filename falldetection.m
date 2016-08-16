function [] = falldetection(vidname)

% finding path where all files in the program are stored
[path,name,ext] = fileparts(mfilename('fullpath'));

% reading the video
vid = vision.VideoFileReader(sprintf('%s\\videos\\%s',path,vidname));

% initializing foreground and blob detectors
detector = vision.ForegroundDetector(...
    'NumTrainingFrames',10,'NumGaussians',5,...
    'MinimumBackgroundRatio', 0.7,'InitialVariance',0.05,...
    'LearningRate',0.0002);
blob = vision.BlobAnalysis(...
    'CentroidOutputPort', true, 'AreaOutputPort', true, ...
    'BoundingBoxOutputPort', true, ...
    'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 500);

%duration of mhi (or) max. value of mhi (or) no of frames taken into acc. for mhi
tmhi = 15;

%strel parameters
strelType = 'square';
strelSize = 5;

%tolerance while find coordinate of y at min. x in counding ellipse
%tolerance for yxmin <= Cy+1 in degrees
noiseYxmin = 3;

%resize Parameter (fraction of input frame)
resizeFactor = 0.25;

%   Fall Detection Parameters
%threshold for detecting high motion
thresMotion = 1.8;
%threshold speed for concluding fall
thSpeed = 2;
%threshold orientation change for concluding fall
thOrChg = 15;
%threshold area change for concluding fall
thAreaChg = 15;
%no of frames that form a fall sequence
noFrFallSeq = 5;

%object that contains possible fall sequences
%object contains ->speed , ->noFrames, ->avgOrChg, ->avgAreaChg
%noFrames - no. of frames that have been taken into acc. till now
posFalls = struct([]);

prevOr = [];

frameNo = 0;
while ~isDone(vid)
    pause(0.0001);
    frame =  step(vid);
    frameNo = frameNo+1;
    %resizing original frame
    %frame = imresize(frame,resizeFactor);
    
    %assigning initial value to motion history image
    if frameNo == 1
        mhimage = zeros(size(frame,1),size(frame,2));
    end
    
    %detecting foreground mask
    fgMask = step(detector,frame);
    %modifying mask to close gaps and fill holes
    fgClose = modifyMask(fgMask,strelType,strelSize);
    
    %finding largest blob
    [area,centroid,box] = step(blob,fgClose);
    pos = find(area==max(area));
    box = box(pos,:);
    
    speed = [];orientation = [];area = [];
    if ~isempty(box)
        %fgBBox - the mask after inside bouding box
        %removing cordinates outside bounding box
        fgBBox = maskInsideBBox(fgClose,box);
        [mhimage,speed] = calcSpeed(mhimage,fgBBox,tmhi);
        if speed >= thresMotion
            posFalls = initializeFallObj(posFalls,size(posFalls,2)+1);
        end
        
        filledCannyMask = logical(edge(fgBBox,'Roberts'));
        [xcoord,ycoord] = coordInsideMask(filledCannyMask,box);
        ellipse = fitellipse(xcoord,ycoord);
        if ~isempty(ellipse)
            orientation = calcOrientation(ellipse,noiseYxmin);
            area = pi*ellipse(3)*ellipse(4);
            
            %output
            subplot(1,4,1);
            imshow(frame);
            title(sprintf('Original Video\nFrame no - %d',frameNo),'FontSize',20);
            subplot(1,4,2);
            imshow(fgMask);
            title(sprintf('Human detection\nFrame no - %d',frameNo),'FontSize',20);
            subplot(1,4,3);
            imshow(uint8((mhimage*255)/tmhi));
            title(sprintf('Motion History Image\nSpeed - %f',speed),'FontSize',20);
            subplot(1,4,4);
            imshow(filledCannyMask);
            drawEllipse(ellipse(1),ellipse(2),ellipse(3),ellipse(4),ellipse(5));
            title(sprintf('Shape of body\nOrientation - %f',orientation),'FontSize',20);
        else
            %output
            subplot(1,4,1);
            imshow(frame);
            title(sprintf('Original Video\nFrame no - %d',frameNo),'FontSize',20);
            subplot(1,4,2);
            imshow(fgMask);
            title(sprintf('Human detection\nFrame no - %d',frameNo),'FontSize',20);
            subplot(1,4,3);
            imshow(uint8((mhimage*255)/tmhi));
            title(sprintf('Motion History Image\nSpeed - '),'FontSize',20);
            subplot(1,4,4);
            imshow(filledCannyMask);
            title(sprintf('Shape of body\nOrientation - '));
        end
    else
        %output
        subplot(1,4,1);
        imshow(frame);
        title(sprintf('Original Video\nFrame no - %d',frameNo),'FontSize',20);
        subplot(1,4,2);
        imshow(fgMask);
        title(sprintf('Human detection\nFrame no - %d',frameNo),'FontSize',20);
        subplot(1,4,3);
        imshow(uint8((mhimage*255)/tmhi));
        title(sprintf('Motion History Image\nSpeed - '),'FontSize',20);
        subplot(1,4,4);
        imshow(zeros(size(fgMask)));
        title(sprintf('Shape of body\nOrientation - %f',orientation),'FontSize',20);
    end
    
    %no possible fall sequences
    if isempty(posFalls)
        if ~isempty(orientation) && ~isempty(area)
            prevOr = orientation;
            prevArea = area;
        else
            %do not increment last changed frame number
        end
        continue;
    end
    
    %no object is found in foreground mask
    if isempty(speed) || isempty(orientation) || isempty(area)
        % speed,orientation change, area change have to assigned a certain
        % value
        posFalls = struct([]);
        %do not increment last changed frame number
        continue;
    end
    
    if isempty(prevOr)
        orChg = 0;
        areaChg = 0;
    else
        orChg = findOrChg(orientation,prevOr);
        areaChg = 20;%have to find it.
    end
    prevOr = orientation;
    prevArea = area;
    [fallDetected,posFalls] = updateCheckPosFalls(posFalls,size(posFalls,2),noFrFallSeq,orChg,areaChg,speed,thOrChg,thAreaChg,thSpeed);
    if fallDetected == true   
        
        subplot(1,4,1);
        imshow(frame);
        title(sprintf('Original Video\nFrame no - %d',frameNo),'FontSize',20);
        subplot(1,4,2);
        imshow(fgMask);
        title(sprintf('FALL DETECTED\n'),'FontSize',50);
        subplot(1,4,3);
        imshow(uint8((mhimage*255)/tmhi));
        title(sprintf('Motion History Image\nSpeed - %f',speed),'FontSize',20);
        subplot(1,4,4);
        imshow(filledCannyMask);
        title(sprintf('Shape of body\nOrientation - %f',orientation),'FontSize',20);
        pause(2);
    end
end

% C:\Users\lenovo\Desktop\programs\matlab\FallDetection>"C:\Program Files\MATLAB\R2013a\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "falldetection video.mp4";
