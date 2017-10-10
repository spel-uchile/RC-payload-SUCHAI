clear all;
close all;

parserFolder = './parser';
preprocessorFolder = './preprocessor';
fixtureFolder = strcat(preprocessorFolder, '/test');
preprocessedFiles = dir(fixtureFolder);
preprocessedFiles = preprocessedFiles(arrayfun(@(x) ~strcmp(x.name(1),'.')...
    ,preprocessedFiles));
preprocessedFiles = {preprocessedFiles.name};
preprocessedFiles = sortn(preprocessedFiles);
saveFolder = strcat(parserFolder,'/test');
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

inputFile = strcat(fixtureFolder, '/', preprocessedFiles{1});
savePrefix = strcat(saveFolder,'/inputTest');
inputParsed = parserInput(inputFile, savePrefix, 15, 0, 1.6);

preprocessedFiles = preprocessedFiles(2:end);
for i = 1 : length(preprocessedFiles)
    currFile = strcat(fixtureFolder,'/', preprocessedFiles{i});
    savePrefix = strcat(saveFolder,'/outputTest', num2str(i));
    outputParsed{i} = parserOutput(currFile, savePrefix, 9, 0, 1.6, 4);
end


