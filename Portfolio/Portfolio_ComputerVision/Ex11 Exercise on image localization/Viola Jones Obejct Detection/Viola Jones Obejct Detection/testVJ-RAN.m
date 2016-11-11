clear all
clc
close all
%%
% 
% srcFiles = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\IMM\*.jpg'); 
% filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\IMM\',srcFiles(i).name);
% for i = 1 : length(srcFiles)
%     filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\IMM\',srcFiles(i).name)
   Options.Resize=false;
    ObjectDetection('test/06.jpg','HaarCascades/haarcascade_frontalface_alt.mat',Options)
% end 
% Options.Resize=false;
% ObjectDetection('Images/1.jpg','HaarCascades/haarcascade_frontalface_alt.mat',Options);
% object = ObjectDetection('Images/1.jpg','HaarCascades/haarcascade_frontalface_alt.mat',Options);
%%
faceDetector = vision.CascadeObjectDetector;
%  srcFiles = dir('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\test\*.jpg'); 
%  filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\test\',srcFiles(i).name);
% for i = 1 : length(srcFiles)
%     filename = strcat('C:\Users\RAN\OneDrive\Documents\ComputerVision\Ex11 Exercise on image localization\Viola Jones Obejct Detection\Viola Jones Obejct Detection\test\',srcFiles(i).name)
I = imread('test/06.jpg');
 bboxes = step(faceDetector, I);
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
   figure, imshow(IFaces), title('Detected faces');
% end


%% PeopleDetector
peopleDetector = vision.PeopleDetector;
I = imread('test/02.jpg');
[bboxes, scores] = step(peopleDetector, I); 
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
     
scoreInserter = vision.TextInserter('Text',' %f','Color', [0 80 255],'LocationSource','Input port','FontSize',16);

 I = step(shapeInserter, I, int32(bboxes));
 I = step(scoreInserter, I, scores, int32(bboxes(:,1:2))); 

figure, imshow(I)
title('Detected people and detection scores'); 
%%
I1 = imread('test/02.jpg');
[hog1, visualization] = extractHOGFeatures(I1,'CellSize',[15 15]);
subplot(1,2,1);
imshow(I1);
subplot(1,2,2);
plot(visualization);
%%
I2 = imread('test/02.jpg');
corners   = detectFASTFeatures(rgb2gray(I2));
strongest = selectStrongest(corners, 100);
[hog2, validPoints, ptVis] = extractHOGFeatures(I2, strongest);
figure;
imshow(I2); hold on;
plot(ptVis, 'Color','green');
