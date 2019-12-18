%% CLEANING
clear;
close all;
clc;

%% EXTRACTION OF FEATURES
% 18 classes of 12 images
folderImages = './images_Kimia216/';
classes = {'bird','bone','brick','camel','car','children',...
    'classic','elephant','face','fork','fountain',...
    'glass','hammer','heart','key','misk','ray','turtle'};
nbClasses = length(classes);
nbImages = 12;

features = [];
targets = zeros(nbClasses,nbClasses*nbImages);

for i=1:nbClasses
    for k=1:nbImages
        nameImage = strcat(folderImages,classes{i},'-',num2str(k),'.bmp');
        currentImage = imread(nameImage);
        currentImage = currentImage==0;
        s  = regionprops(currentImage,'Area','ConvexArea',...
            'Eccentricity','EquivDiameter','Extent',...
            'MajorAxisLength','MinorAxisLength',...
            'Perimeter','Solidity');
        sArray = [s.Area;s.ConvexArea;s.Eccentricity;...
            s.EquivDiameter;s.Extent;...
            s.MajorAxisLength;s.MinorAxisLength;...
            s.Perimeter;s.Solidity];
        features = [features,sArray(:,1)];       
    end
    targets(i,(i-1)*nbImages+[1:nbImages]) = 1;
end

%% CLASSIFICATION
% create the network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% set up the division of data
net.divideParam.trainRatio = 75/100;
%net.divideParam.valRatio   = 20/100;
net.divideParam.testRatio  = 25/100;

% train the network
[net,tr] = train(net,features,targets);

% test the network
outputs = net(features);

% overall performance
[c,cm,ind,per] = confusion(targets,outputs);
perf = 1-c
%figure; plotperform(tr);

% confusion matrix
figure; plotconfusion(targets,outputs);

