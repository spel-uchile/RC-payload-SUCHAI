function [pdfValue, xbins, bandWidth, OtherParameters] = pdfEstimator(tSeries, varargin)

frequency = tSeries.fsignal;
tsCollection = tSeries.tsc;
kernel = 'normal';
npoints = 100;
typeOfFunction = 'pdf';
kindOfNorm = 'raw';

if nargin > 2
    switch length(varargin)
        case 1
            npoints = varargin{1};
        case 2
            npoints = varargin{1};
            kernel = varargin{2};
        case 3
            npoints = varargin{1};
            kernel = varargin{2};
            kindOfNorm = varargin{3};
        case 4
            npoints = varargin{1};
            kernel = varargin{2};
            kindOfNorm = varargin{3};
            bwStruct = varargin{4};
        otherwise
            error('too many arguments');
    end
end

vin = tsCollection.Vin.Data;
vout = tsCollection.Vout.Data;
vR = tsCollection.Vr.Data;
iR = tsCollection.Ir.Data;
iC = tsCollection.Ic.Data;
pIn = tsCollection.pIn.Data;
pR = tsCollection.Pr.Data;
pC = tsCollection.Pc.Data;
deltaP = tsCollection.DeltaPower.Data;
langDiss = tsCollection.langevinDissipated.Data;
langInj = tsCollection.langevinInjected.Data;
langStored = tsCollection.langevinStored.Data;
langDeltaP = tsCollection.langevinDeltaPower.Data;

% switch kindOfNorm
%     case 'raw'
%         ptsVin = linspace(-0.25, 2.25, npoints);
%         ptsVout = ptsVin;
%         ptsVr = linspace(-6, 6, npoints);
%     case 'divByMean'
%
%     case 'diffByMeanDivByStd'
%         ptsVin = linspace(-1.25, 1.25, npoints);
%         ptsVout = ptsVin;
%         ptsVr = linspace(-6, 6, npoints);
%         ptsPin = linspace(-0.2, 1.2, npoints);
%         ptsPr = linspace(-0.2, 2.5, npoints);
%         ptsPc = ptsPin;
%         ptsDeltaP = ptsPin;
% end

if isempty(bwStruct)
    %     [fVin, ptsVin, bwVin] = ksdensity(vin,ptsVin, 'kernel',kernel);
    %     [fVout, ptsVout, bwVout] = ksdensity(vout,ptsVout, 'kernel',kernel);
    %     [fVr, ptsVr, bwVr] = ksdensity(vR, ptsVr, 'kernel',kernel);
    %     [fIr, ptsIr, bwIr] = ksdensity(iR, 'kernel',kernel);
    %     [fIc, ptsIc, bwIc] = ksdensity(iC, 'kernel',kernel);
    %     [fPin, ptsPin, bwPin] = ksdensity(pIn, ptsPin,'kernel',kernel);
    %     [fPr, ptsPr, bwPr] = ksdensity(pR, ptsPr, 'kernel',kernel);
    %     [fPc, ptsPc, bwPc] = ksdensity(pC, ptsPc, 'kernel',kernel);
    %     [fDeltaP, ptsDeltaP, bwDeltaP] = ksdensity(deltaP, ptsDeltaP, 'kernel',kernel);
    %     [fLangInj, ptsLangInj, bwLangInj] = ksdensity(langInj, 'kernel',kernel);
    %     [fLangDiss, ptsLangDiss, bwLangDiss] = ksdensity(langDiss, 'kernel',kernel);
    %     [fLangStored, ptsLangStored, bwLangStored] = ksdensity(langStored, 'kernel',kernel);
    %     [fLangDelta, ptsLangDeltaP, bwLangDeltaP] = ksdensity(langDeltaP, 'kernel',kernel);
    [fVin, ptsVin, bwVin] = ksdensity(vin, 'kernel',kernel);
    [fVout, ptsVout, bwVout] = ksdensity(vout, 'kernel',kernel);
    [fVr, ptsVr, bwVr] = ksdensity(vR,  'kernel',kernel);
    [fIr, ptsIr, bwIr] = ksdensity(iR, 'kernel',kernel);
    [fIc, ptsIc, bwIc] = ksdensity(iC, 'kernel',kernel);
    [fPin, ptsPin, bwPin] = ksdensity(pIn, 'kernel',kernel);
    [fPr, ptsPr, bwPr] = ksdensity(pR,  'kernel',kernel);
    [fPc, ptsPc, bwPc] = ksdensity(pC,  'kernel',kernel);
    [fDeltaP, ptsDeltaP, bwDeltaP] = ksdensity(deltaP,  'kernel',kernel);
    [fLangInj, ptsLangInj, bwLangInj] = ksdensity(langInj, 'kernel',kernel);
    [fLangDiss, ptsLangDiss, bwLangDiss] = ksdensity(langDiss, 'kernel',kernel);
    [fLangStored, ptsLangStored, bwLangStored] = ksdensity(langStored, 'kernel',kernel);
    [fLangDelta, ptsLangDeltaP, bwLangDeltaP] = ksdensity(langDeltaP, 'kernel',kernel);
    
else
    [fVin, ptsVin, bwVin] = ksdensity(vin,ptsVin, 'kernel',kernel, 'bandwidth', bwStruct.Vin);
    [fVout, ptsVout, bwVout] = ksdensity(vout,ptsVout, 'kernel',kernel, 'bandwidth', bwStruct.Vout);
    [fVr, ptsVr, bwVr] = ksdensity(vR, ptsVr, 'kernel',kernel, 'bandwidth', bwStruct.Vr);
    [fIr, ptsIr, bwIr] = ksdensity(iR, 'kernel',kernel, 'bandwidth', bwStruct.Ir);
    [fIc, ptsIc, bwIc] = ksdensity(iC, 'kernel',kernel, 'bandwidth', bwStruct.Ic);
    [fPin, ptsPin, bwPin] = ksdensity(pIn, ptsPin,'kernel',kernel, 'bandwidth', bwStruct.Pin);
    [fPr, ptsPr, bwPr] = ksdensity(pR, ptsPr, 'kernel',kernel, 'bandwidth', bwStruct.Pr);
    [fPc, ptsPc, bwPc] = ksdensity(pC, ptsPc, 'kernel',kernel, 'bandwidth', bwStruct.Pc);
    [fDeltaP, ptsDeltaP, bwDeltaP] = ksdensity(deltaP, ptsDeltaP, 'kernel',kernel, 'bandwidth', bwStruct.DeltaP);
    [fLangInj, ptsLangInj, bwLangInj] = ksdensity(langInj, 'kernel',kernel, 'bandwidth', bwStruct.LangInj);
    [fLangDiss, ptsLangDiss, bwLangDiss] = ksdensity(langDiss, 'kernel',kernel, 'bandwidth', bwStruct.LangDiss);
    [fLangStored, ptsLangStored, bwLangStored] = ksdensity(langStored, 'kernel',kernel, 'bandwidth', bwStruct.LangStored);
    [fLangDelta, ptsLangDeltaP, bwLangDeltaP] = ksdensity(langDeltaP, 'kernel',kernel, 'bandwidth', bwStruct.LangDeltaP);
end

pdfValue.Vin = normalize(ptsVin, fVin);
pdfValue.Vout = normalize(ptsVout, fVout);
pdfValue.Vr = normalize(ptsVr, fVr);
pdfValue.Ir = normalize(ptsIr, fIr);
pdfValue.Ic = normalize(ptsIc, fIc);
pdfValue.Pin = normalize(ptsPin, fPin);
pdfValue.Pr = normalize(ptsPr, fPr);
pdfValue.Pc = normalize(ptsPc, fPc);
pdfValue.DeltaP = normalize(ptsDeltaP, fDeltaP);
pdfValue.LangInj = normalize(ptsLangInj, fLangInj);
pdfValue.LangDiss = normalize(ptsLangDiss, fLangDiss);
pdfValue.LangStored = normalize(ptsLangStored, fLangStored);
pdfValue.LangDeltaP = normalize(ptsLangDeltaP, fLangDelta);

xbins.Vin = ptsVin;
xbins.Vout = ptsVout;
xbins.Vr = ptsVr;
xbins.Ir = ptsIr;
xbins.Ic = ptsIc;
xbins.Pin = ptsPin;
xbins.Pr = ptsPr;
xbins.Pc = ptsPc;
xbins.DeltaP = ptsDeltaP;
xbins.LangInj = ptsLangInj;
xbins.LangDiss = ptsLangDiss;
xbins.LangStored = ptsLangStored;
xbins.LangDeltaP = ptsLangDeltaP;

bandWidth.Vin = bwVin;
bandWidth.Vout = bwVout;
bandWidth.Vr = bwVr;
bandWidth.Ir = bwIr;
bandWidth.Ic = bwIc;
bandWidth.Pin = bwPin;
bandWidth.Pr = bwPr;
bandWidth.Pc = bwPc;
bandWidth.DeltaP = bwDeltaP;
bandWidth.LangInj = bwLangInj;
bandWidth.LangDiss = bwLangDiss;
bandWidth.LangStored = bwLangStored;
bandWidth.LangDeltaP = bwLangDeltaP;

if ~isempty(cell2mat(strfind(fieldnames(tsCollection), 'Math')))  %only true for tektronix
    math =  tsCollection.Math.Data;
    ptsMath = (ptsVin.*1000)./2; %math esta en mV^2
    [fMath, ptsMath, bwMath] = ksdensity(math,ptsMath, 'kernel',kernel);
    pdfValue.Math = normalize(ptsMath, fMath);
    xbins.Math = ptsMath;
    bandWidth.Math = bwMath;
end

OtherParameters.kernel = kernel;
OtherParameters.npoints = npoints;
OtherParameters.function = typeOfFunction;
OtherParameters.fsignal = frequency;

end