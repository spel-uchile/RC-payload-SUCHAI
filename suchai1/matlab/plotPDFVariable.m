function plotPDFVariable(subFolderName, givenXLims, givenYLims, XUnits)
%PLOTPDFVARIABLE    Plots the estimated PDF of one f the random variables
%computed.
global matfileTM;
global matfileLab;
global suchaiFoldersName;
global saveFolder;
global mkrsize,
global freqsLegendTM;
global tmPerFreqSuchai;
global freqsLegendLab;
global tmPerFreqLab;
ks = 1;
kl = 1;
% subFolderName = 'LangDiss';
saveFolderFig = [saveFolder , '/', subFolderName];
if ~isdir(saveFolderFig)
    mkdir(saveFolderFig);
end
for i = 1 : numel(suchaiFoldersName)
    figure('units','normalized','outerposition',[0 0 1 1]);
    currLegendSuchai = freqsLegendTM(ks:ks+tmPerFreqSuchai(i)-1);
    for j = 1 : tmPerFreqSuchai(i)
        xbins = matfileTM{ks}.xbins;
        pdfResult = matfileTM{ks}.pdfResult;
        hold on;
        theName = fieldnames(xbins);
        theName = theName{1};
        plot(xbins.(theName).(subFolderName), log10(pdfResult.(theName).(subFolderName)),'*','MarkerSize', mkrsize);
        hold off;
        ks = ks +1;
    end
    currLegendLab = freqsLegendLab(kl:kl+tmPerFreqLab(i)-1);
    for j = 1 : tmPerFreqLab(i)
        xbins = matfileLab{kl}.xbins;
        pdfResult = matfileLab{kl}.pdfResult;
        hold on;
        theName = fieldnames(xbins);
        theName = theName{1};
        plot(xbins.(theName).(subFolderName), log10(pdfResult.(theName).(subFolderName)),'o','MarkerSize', mkrsize);
        hold off;
        kl = kl + 1;
    end
    grid on;
    if ~isempty(givenYLims)
        ylim(givenYLims);
    end
    if ~isempty(givenXLims)
        xlim(givenXLims);
    end
    yt = get(gca, 'YTick');
    myylabels = cellstr(num2str(yt(:), '10^{%.1f}'));
    set(gca,'YTickLabel', myylabels);
    set(gca, 'YMinorTick','on', 'YMinorGrid','on');
    title([subFolderName,' PDF ', num2str(str2double(suchaiFoldersName{i})/91.5), ' f_{RC}']);
    xlabel(XUnits);
    currLegend = [currLegendSuchai, currLegendLab]';
    hleg = legend(currLegend,'Location','eastoutside','Orientation','vertical');
    set(hleg, 'Interpreter', 'none');
    figSaveName = [saveFolderFig, '/',suchaiFoldersName{i},'_',subFolderName,'_',date,'.png'];
    saveas(gcf, figSaveName);
end
end