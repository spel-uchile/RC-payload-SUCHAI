clear all;
close all;

plotFolder = './img/parameters/';
date = {'2016_17_05', '2016_18_05'};
yMax = 1e1;
yMin = 1e-4;
eqNum = 3;
for k = 1 : length(date)
    prefix = strcat(date{k},'_');
    matFileName = strcat(prefix,'DistributionParameters.mat');
    load(matFileName)
    
    names = fieldnames(Parameters);
    f = Parameters.freq;
    x = f;
    y = Parameters.theoVar;
    
    %% Only simulation / fit
    fitEquation{1} ='a*(f + b)/(f + c)^2 + d*(f/(f + e)^2)';
    fitEquation{2} = 'a*log10(f)^2 + b*log10(f) + c';
    fitEquation{3} = '(a*f)/(f + b)^2';
    coeffs{1} =  {'a','b','c','d','e'};
    coeffs{2} =  {'a','b','c'};
    coeffs{3} =  {'a','b'};
    theoFitType = fittype(fitEquation{eqNum},'independent',{'f'},'coefficients',coeffs{eqNum});
    [fitObjTheo, godness, ~] = fit(x.', y.', theoFitType);
    fCoeffs = coeffvalues(fitObjTheo);
    
    xfit = logspace(1, 5, 1000);
    switch eqNum
        case 1
            yfit = (fCoeffs(1).* (xfit + fCoeffs(2)))./((xfit + fCoeffs(3)).^2)...
                + (fCoeffs(4).* xfit)./((xfit + fCoeffs(5)).^2);
        case 2
            yfit = fCoeffs(1).*(log10(xfit).^2) + fCoeffs(2).*log10(xfit)+ fCoeffs(3);
        case 3
            yfit = (fCoeffs(1).*(xfit)./((xfit + fCoeffs(2)).^2));
        otherwise
            error('invalid number');
    end
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    colorOrder = get(gca, 'ColorOrder');
    modelColor = colorOrder(mod(length(get(gca, 'Children')), size(colorOrder, 1))+2, :);
    loglog(f, Parameters.theoVar,'.', xfit,yfit);
    ylim([yMin yMax]);
    legend('simulation variance',...
        strcat('model R_{adj}^{2} = ',num2str(godness.adjrsquare)));
    textX = 10;
    textY = 0.02;
    text(textX,textY,strcat('\sigma^{2} = ',fitEquation{eqNum}), ...
        'Color',modelColor,'FontSize',20, 'HorizontalAlignment','left');
    xlabel('Signal Frequency [Hz]')
    title('Vout Variance and Signal frequency relation');
    grid on;
    saveas(gcf,strcat(plotFolder,prefix,'varianceFit','.png'));
    
    %% All three
    figure('units','normalized','outerposition',[0 0 1 1]);
    colorOrder = get(gca, 'ColorOrder');
    modelColor = colorOrder(mod(length(get(gca, 'Children')), size(colorOrder, 1))+2, :);
    loglog(f, Parameters.theoVar,'.', xfit,yfit, f, Parameters.realVar,'o');
    ylim([yMin yMax]);
    legend('simulation variance',...
        strcat('model R_{adj}^{2} = ',num2str(godness.adjrsquare)), 'experimental variance');
    textX = 10;
    textY = 0.02;
    text(textX,textY,strcat('\sigma^{2} = ',fitEquation{eqNum}), ...
        'Color',modelColor,'FontSize',20, 'HorizontalAlignment','left');
    xlabel('Signal Frequency [Hz]')
    title('Vout Variance and Signal frequency relation');
    grid on;
    saveas(gcf,strcat(plotFolder,prefix,'varianceFit_AllThree','.png'));
    
    %% Error measured in %
    xerror = f;
    switch eqNum
        case 1
            yerror = (fCoeffs(1).* (xerror + fCoeffs(2)))./((xerror + fCoeffs(3)).^2)...
                + (fCoeffs(4).* xerror)./((xerror + fCoeffs(5)).^2);
        case 2
            yerror = fCoeffs(1).*(log10(xerror).^2) + fCoeffs(2).*log10(xerror)+ fCoeffs(3);
        case 3
            yerror = (fCoeffs(1).*(xerror)./((xerror + fCoeffs(2)).^2));
        otherwise
            error('invalid number');
    end
    
    errorVar = abs((yerror - Parameters.realVar) ./ yerror);
    fitErr = fit(xerror.',errorVar.','poly1');
    errorCoeffs = coeffvalues(fitErr);
    errorXFit = logspace(1, log10(max(f)), 1000);
    errorYfit = polyval(errorCoeffs,errorXFit);
    figure('units','normalized','outerposition',[0 0 1 1]);
    semilogx(f, errorVar.*100, errorXFit, errorYfit.*100);
    ylim([0 130]);
    xlabel('Hz');
    ylabel('%');
    title('Error between experimental variance and expected variance for Vout pdf');
    legend('variance error','variance error tendency');
    
    grid on;
    saveas(gcf,strcat(plotFolder,prefix,'varianceError','.png'));
end