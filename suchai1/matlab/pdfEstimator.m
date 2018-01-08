function [pdfValue, xbins, bandWidth, OtherParameters] = pdfEstimator(tSeries, varargin)

frequency = tSeries.fsignal;
tsCollection = tSeries.tsc;
kernel = 'normal';
npoints = 100;
typeOfFunction = 'pdf';

if nargin > 2
    switch length(varargin)
        case 1
            npoints = varargin{1};
        case 2
            npoints = varargin{1};
            kernel = varargin{2};
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

% dampingRate = tSeries.dampingRate;
% ptsVin = linspace(tSeries.minVin, tSeries.maxVin, npoints);
% ptsVout = ptsVin;
% ptsVr = ptsVin;
% ptsPin = linspace(-0.2, 1, npoints); %in mW
% ptsPr = ptsPin;
% ptsPc = ptsPin;
% ptsDeltaP = ptsPin;
% ptsIr = linspace(-1, 1, npoints);
% ptsIc = linspace(-0.15, 0.15, npoints);
% ptsLangInj = linspace(-0.2*dampingRate, 0.2*dampingRate, npoints);
% ptsLangDiss = ptsLangInj;
% ptsLangStored = ptsLangInj;
% ptsLangDeltaP = ptsLangInj;
% [fVin, ~, bw(1)] = ksdensity(vin, ptsVin,'kernel',kernel);
% [fVout, ~, bw(2)] = ksdensity(vout, ptsVout,'kernel',kernel);
% [fVr, ~, bw(3)] = ksdensity(vR, ptsVr,'kernel',kernel);
% [fIr, ~, bw(4)] = ksdensity(iR, ptsIr,'kernel',kernel);
% [fIc, ~, bw(5)] = ksdensity(iC, ptsIc,'kernel',kernel);
% [fPin, ~, bw(6)] = ksdensity(pIn, ptsPin,'kernel',kernel);
% [fPr, ~, bw(7)] = ksdensity(pR, ptsPr,'kernel',kernel);
% [fPc, ~, bw(8)] = ksdensity(pC, ptsPc,'kernel',kernel);
% [fDeltaP, ~, bw(9)] = ksdensity(deltaP, ptsDeltaP,'kernel',kernel);
% [fLangInj, ~, bw(11)] = ksdensity(langInj, ptsLangInj,'kernel',kernel);
% [fLangDiss, ~, bw(12)] = ksdensity(langDiss, ptsLangDiss,'kernel',kernel);
% [fLangStored, ~, bw(13)] = ksdensity(langStored, ptsLangStored,'kernel',kernel);
% [fLangDelta, ~, bw(14)] = ksdensity(langDeltaP, ptsLangDelta,'kernel',kernel);

[fVin, ptsVin, bwVin] = ksdensity(vin, 'kernel',kernel);
[fVout, ptsVout, bwVout] = ksdensity(vout, 'kernel',kernel);
[fVr, ptsVr, bwVr] = ksdensity(vR,'kernel',kernel);
[fIr, ptsIr, bwIr] = ksdensity(iR, 'kernel',kernel);
[fIc, ptsIc, bwIc] = ksdensity(iC, 'kernel',kernel);
[fPin, ptsPin, bwPin] = ksdensity(pIn, 'kernel',kernel);
[fPr, ptsPr, bwPr] = ksdensity(pR, 'kernel',kernel);
[fPc, ptsPc, bwPc] = ksdensity(pC, 'kernel',kernel);
[fDeltaP, ptsDeltaP, bwDeltaP] = ksdensity(deltaP, 'kernel',kernel);
[fLangInj, ptsLangInj, bwLangInj] = ksdensity(langInj, 'kernel',kernel);
[fLangDiss, ptsLangDiss, bwLangDiss] = ksdensity(langDiss, 'kernel',kernel);
[fLangStored, ptsLangStored, bwLangStored] = ksdensity(langStored, 'kernel',kernel);
[fLangDelta, ptsLangDeltaP, bwLangDeltaP] = ksdensity(langDeltaP, 'kernel',kernel);

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

OtherParameters.kernel = kernel;
OtherParameters.npoints = npoints;
OtherParameters.function = typeOfFunction;
OtherParameters.fsignal = frequency;

end