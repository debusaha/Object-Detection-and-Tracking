% Define the image directory and the corresponding label directory
imDir =  'C:\Users\itsde\Desktop\Trapping\Trapping';
pxDir = 'C:\Users\itsde\Desktop\Trapping\MASK';

% Create an imageDatastore for the images and pixelLabelDatastore for the labels
imds = imageDatastore(imDir);
classNames = ["background","object"]; % Define your classes here
labelIDs   = [0 1]; % Define your label IDs here
pxds = pixelLabelDatastore(pxDir,classNames,labelIDs);

% Define the image size and number of classes
imageSize = [1024 1024 1];
numClasses = numel(classNames);

% Define your own network architecture
lgraph = createMyNetwork(imageSize, numClasses); % replace 'createMyNetwork' with your function

% Define training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',15, ...
    'MiniBatchSize',64);

% Train the network
net = trainNetwork(imds,pxds,lgraph,options);

function lgraph = createMyNetwork(imageSize, numClasses)
    layers = [
        imageInputLayer(imageSize,'Name','input')
        
        convolution2dLayer(3,8,'Padding','same','Name','conv_1')
        reluLayer('Name','relu_1')
        
        
        convolution2dLayer(3,16,'Padding','same','Name','conv_2')
        reluLayer('Name','relu_2')
        
        
        convolution2dLayer(3, numClasses,'Padding','same','Name','conv_3')
        softmaxLayer('Name','output');
    
    lgraph = layerGraph(layers);
end