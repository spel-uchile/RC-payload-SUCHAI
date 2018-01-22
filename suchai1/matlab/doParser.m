clear dir;
prefix = '2018_01_17_123317';  %date and foldername of logs
parserFolder = './parser/suchai';
preprocessorFolder = './preprocessor/suchai';
fixtureFolder = strcat(preprocessorFolder, '/', prefix);
preprocessedFiles = dir(fixtureFolder);
preprocessedFiles = {preprocessedFiles.name};
preprocessedFiles = preprocessedFiles(3:end)';
preprocessedFiles = sortn(preprocessedFiles);

saveFolder = strcat(parserFolder,'/', prefix);
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

savePrefix = strcat(saveFolder,'/', prefix,'_');
ninputs = 1;
for i = 1 : ninputs
    currFile = strcat(fixtureFolder,'/', preprocessedFiles{i});
    savePrefix = strcat(saveFolder,'/', 'InputCounts', num2str(i),'_', prefix);
    inputParsed{i} = parserInput(currFile, savePrefix, 16, 0, 3.3);
end


for i = ninputs + 1 : length(preprocessedFiles)
    k = i-ninputs;
    currFile = strcat(fixtureFolder,'/', preprocessedFiles{i});
    savePrefix = strcat(saveFolder,'/', 'OutputCounts', num2str(k),'_', prefix);
    outputParsed{k} = parserOutput(currFile, savePrefix, 10, 0, 3.3, 4);
end