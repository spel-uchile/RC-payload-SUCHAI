figure;
for names = {'Vin','Vout'}
    variableName = names{1};
    rootDir= './mat/pdf';
    mkrsize = 6;
    plot(xbins.raw.(variableName), log10(pdfResult.raw.(variableName)),'*','MarkerSize', mkrsize);
    hold on;
end

figure;
for names = {'LangInj', 'LangDiss'}
    variableName = names{1};
    rootDir= './mat/pdf';
    mkrsize = 6;
    plot(xbins.raw.(variableName), log10(pdfResult.raw.(variableName)),'*','MarkerSize', mkrsize);
    hold on;
end