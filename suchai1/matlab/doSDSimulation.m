prefix ='2016_18_05';
parserFolder = './parser';
fixtureFolder = strcat(parserFolder,'/', prefix);
parserFiles = dir(fixtureFolder);
parserFiles = {parserFiles.name};
parserFiles = parserFiles(3:end)';
parserFiles = sortn(parserFiles);

charIndexForInputFixture = strfind(lower(parserFiles), 'input');
fixtureIndexForInputParserFiles = find(~cellfun(@isempty, charIndexForInputFixture));
inputFixture = strcat(fixtureFolder,'/', parserFiles{fixtureIndexForInputParserFiles});
outputFixture = cell(1, length(parserFiles) - 1);
fixtureIndexForOutputFiles = 0;

for i = 2 : length(parserFiles)
    
    inputFixture = strcat(fixtureFolder,'/', parserFiles{1});
    outputFixture = strcat(fixtureFolder,'/', parserFiles{i});
    S = load(outputFixture);
    name = fieldnames(S);
    
    adcPeriod = S.(name{1}).adcPeriod;
    sampCoeff = S.(name{1}).oversamplingCoeff;
    
    fsignal = computeFreqSignalHz(adcPeriod, sampCoeff);    %try different values
    Parameters.dacBits = 16;
    Parameters.dacMaxVoltage = 3.3;
    Parameters.dacMinvoltage = 0;
    Parameters.oversamplingCoeff = 4;
    Parameters.adcMaxVoltage = 3.3;
    Parameters.adcMinVoltage = 0;
    Parameters.adcBits = 10;
    Parameters.buffLen = 400;   %try with 200
    Parameters.adcPeriod = adcPeriod;
    Parameters.sampledValuesPerRound = floor(Parameters.buffLen / Parameters.oversamplingCoeff);
    Parameters.rounds = 3;
    Parameters.nWaitingUnits = 350; %check if is good enough
    Parameters.nonSampledValuesPerRound = 500;  %try different values
    
    saveFolder = [pwd, '/mat/memSD/', prefix,'/',num2str(fsignal),'/'];
    if ~isdir(saveFolder)
        mkdir(saveFolder)
    end
    
    [op1, op1Sampled]= simulationFactory(fsignal, 'option1', Parameters);
    save(strcat(saveFolder, 'op1_', num2str(fsignal),'Hz.mat'),'op1','op1Sampled','-v7.3');
    [op2, op2Sampled]= simulationFactory(fsignal, 'option2', Parameters);
    save(strcat(saveFolder, 'op2_', num2str(fsignal),'Hz.mat'),'op2','op2Sampled','-v7.3');
    [op3, op3Sampled] = simulationFactory(fsignal, 'option3', Parameters);
    save(strcat(saveFolder, 'op3_', num2str(fsignal),'Hz.mat'),'op3','op3Sampled','-v7.3');
    [op1op3, op1op3Sampled] = simulationFactory(fsignal, 'option1+3', Parameters);
    save(strcat(saveFolder, 'op1op3_', num2str(fsignal),'Hz.mat'),'op1op3','op1op3Sampled','-v7.3');
    Parameters.numberOfRandomValues = 2e4;
    theoretical = simulationFactory(fsignal, 'theoretical', Parameters);
    save(strcat(saveFolder, 'theoretical_', num2str(fsignal),'Hz.mat'),'theoretical','-v7.3');
    
    
    %% Option 1, Option 2, Option3
    nPlots = 3;
    numberOfBins = 71;
    binLimits = [-0.85 0.85];
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(nPlots, 2, 1);
    plot(op1.tsc.Vin);
    hold on;
    plot(op1.tsc.Vout);
    title('Option 1 (SUCHAI 1)');
    xlabel(op1.tsc.Vin.TimeInfo.Units);
    ylabel(op1.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,2);
    h1 = histogram(hAxes, op1.tsc.Vout.Data);
    h1.BinLimits = binLimits;
    h1.NumBins = numberOfBins;
    xlabel(op1.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots, 2, 3);
    plot(op2.tsc.Vin);
    hold on;
    plot(op2.tsc.Vout);
    title('Option 2');
    xlabel(op2.tsc.Vin.TimeInfo.Units);
    ylabel(op2.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,4);
    h2 = histogram(hAxes, op2.tsc.Vout.Data);
    h2.BinLimits = binLimits;
    h2.NumBins = numberOfBins;
    xlabel(op2.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots, 2, 5);
    plot(op3.tsc.Vin);
    hold on;
    plot(op3.tsc.Vout);
    title('Option 3');
    xlabel(op3.tsc.Vin.TimeInfo.Units);
    ylabel(op3.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,6);
    h3 = histogram(hAxes, op3.tsc.Vout.Data);
    h3.BinLimits = binLimits;
    h3.NumBins = numberOfBins;
    xlabel(op3.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    %     pA = mtit(['How to resume execution when buffer is full (cmd value ', ...
    %         num2str(adcPeriod) ,' / ',num2str(fsignal), ' Hz)'],...
    %         'yoff',.15);
    pause(1);
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_op1op2op3_', ...
        num2str(fsignal),'.eps'],'epsc');
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_op1op2op3_', ...
        num2str(fsignal),'.png']);
    
    %% Option 1 (complete and samples-only)
    nPlots = 2;
    binLimits = [-0.85 0.85];
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(nPlots,2,1)
    plot(op1.tsc.Vin);
    hold on;
    plot(op1.tsc.Vout);
    title('Option 1 - Complete');
    xlabel(op1.tsc.Vin.TimeInfo.Units);
    ylabel(op1.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,2);
    h1 = histogram(hAxes, op1.tsc.Vout.Data);
    h1.BinLimits = binLimits;
    h1.NumBins = numberOfBins;
    xlabel(op1.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots,2,3)
    plot(op1Sampled.tsc.Vin);
    hold on;
    plot(op1Sampled.tsc.Vout);
    title('Option 1 - Samples only ');
    xlabel(op1Sampled.tsc.Vin.TimeInfo.Units);
    ylabel(op1Sampled.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,4);
    h1S = histogram(hAxes, op1Sampled.tsc.Vout.Data);
    h1S.BinLimits = binLimits;
    h1S.NumBins = numberOfBins;
    xlabel(op1Sampled.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    %     pB=mtit(['How to resume execution when buffer is full (cmd value ', ...
    %         num2str(adcPeriod) ,' / ',num2str(fsignal), ' Hz)'],...
    %         'yoff',.15);
    
    pause(1);
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_suchai1_',...
        num2str(fsignal),'.eps'],'epsc');
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_suchai1_',...
        num2str(fsignal),'.png']);
    
    %% Option 1+3 (complete and samples-only)
    nPlots = 2;
    binLimits = [-0.85 0.85];
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(nPlots,2,1);
    plot(op1op3.tsc.Vin);
    hold on;
    plot(op1op3.tsc.Vout);
    title('Option 1 & Option 3 - Complete');
    xlabel(op1op3.tsc.Vin.TimeInfo.Units);
    ylabel(op1op3.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,2);
    h13 = histogram(hAxes, op1op3.tsc.Vout.Data);
    h13.BinLimits = binLimits;
    h13.NumBins = numberOfBins;
    xlabel(op1op3.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots,2,3);
    plot(op1op3Sampled.tsc.Vin);
    hold on;
    plot(op1op3Sampled.tsc.Vout);
    title('Option 1 & Option 3 - Samples only');
    xlabel(op1op3Sampled.tsc.Vin.TimeInfo.Units);
    ylabel(op1op3Sampled.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,4);
    h13S = histogram(hAxes, op1op3Sampled.tsc.Vout.Data);
    h13S.BinLimits = binLimits;
    h13S.NumBins = numberOfBins;
    xlabel(op1op3Sampled.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    %     pC = mtit(['How to resume execution when buffer is full (cmd value ', ...
    %         num2str(adcPeriod) ,' / ',num2str(fsignal), ' Hz)'],...
    %         'yoff',.15);
    pause(1);
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_suchai2_',...
        num2str(fsignal),'.eps'],'epsc');
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_suchai2_',...
        num2str(fsignal),'.png']);
    
    %% Comparison SUCHA 1, SUCHAI 2 and theory (samples-only)
    nPlots = 3;
    
    subplot(nPlots,2,1)
    plot(op1Sampled.tsc.Vin);
    hold on;
    plot(op1Sampled.tsc.Vout);
    title('Option 1 (SUCHAI 1)');
    xlabel(op1Sampled.tsc.Vin.TimeInfo.Units);
    ylabel(op1Sampled.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,2);
    h1S = histogram(hAxes, op1Sampled.tsc.Vout.Data);
    h1S.BinLimits = binLimits;
    h1S.NumBins = numberOfBins;
    xlabel(op1Sampled.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots,2,3);
    plot(op1op3Sampled.tsc.Vin);
    hold on;
    plot(op1op3Sampled.tsc.Vout);
    title('Option 1 & Option 3  (SUCHAI 2)');
    xlabel(op1op3Sampled.tsc.Vin.TimeInfo.Units);
    ylabel(op1op3Sampled.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,4);
    h13S = histogram(hAxes, op1op3Sampled.tsc.Vout.Data);
    h13S.BinLimits = binLimits;
    h13S.NumBins = numberOfBins;
    xlabel(op1op3Sampled.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    subplot(nPlots,2,5);
    plot(theoretical.tsc.Vin);
    hold on;
    plot(theoretical.tsc.Vout);
    title('Theoretical');
    xlabel(theoretical.tsc.Vin.TimeInfo.Units);
    ylabel(theoretical.tsc.Vin.DataInfo.Units);
    legend('vin','vout');
    
    hAxes = subplot(nPlots,2,6);
    hT = histogram(hAxes, theoretical.tsc.Vout.Data);
    hT.BinLimits = binLimits;
    hT.NumBins = numberOfBins;
    xlabel(theoretical.tsc.Vout.DataInfo.Units);
    ylabel('Counts');
    legend('vout');
    
    pause(1);
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_theory-difference_',...
        num2str(fsignal),'.eps'],'epsc');
    saveas(gcf,[pwd '/img/',prefix,'_SDSimulation/', date,'_theory-difference_',...
        num2str(fsignal),'.png']);
    
    close all;
end