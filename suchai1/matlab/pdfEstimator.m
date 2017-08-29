function [pdfValue, xbins, EstimationParameters] = pdfEstimator(tSeries, varargin)

frequency = tSeries.fsignal;
tsCollection = tSeries.tsc;
kernel = 'normal';
npoints = 100;
typeOfFunction = 'pdf';
bw = [];
if nargin > 2
    switch length(varargin)
        case 1
            bw = varargin{1};
        case 2
            bw = varargin{1};
            npoints = varargin{2};
        case 3
            bw = varargin{1};
            npoints = varargin{2};
            kernel = varargin{3};
        otherwise fueron en collera 65 kg
            error('too many arguments');
    end
end
vin = tsCollection.Vin.Data;
vout = tsCollection.Vout.Data;
power = tsCollection.injectedPower.Data;

ptsVin = linspace(tSeries.minVin, tSeries.maxVin, npoints);
ptsVout = ptsVin;
dampingRate = tSeries.dampingRate;
ptsPower = linspace(-0.2*dampingRate, 0.2*dampingRate, npoints);

if ~isempty(bw)
    [fVin, ~, bw(1)] = ksdensity(vin, ptsVin,'kernel',kernel,...
        'Bandwidth',bw(1));
    [fVout, ~, bw(2)] = ksdensity(vout, ptsVout,'kernel',kernel, ...
        'Bandwidth',bw(2));
    [fPower, ~, bw(3)] = ksdensity(power, ptsPower,'kernel',kernel,...
        'Bandwidth',bw(3));
else
    [fVin, ~, bw(1)] = ksdensity(vin, ptsVin,'kernel',kernel);
    [fVout, ~, bw(2)] = ksdensity(vout, ptsVout,'kernel',kernel);
    [fPower, ~, bw(3)] = ksdensity(power, ptsPower,'kernel',kernel);
end

pdfValue.Vin = normalize(ptsVin, fVin);
pdfValue.Vout = normalize(ptsVout, fVout);
pdfValue.injectedPower = normalize(ptsPower, fPower);

xbins.Vin = ptsVin;
xbins.Vout = ptsVout;
xbins.injectedPower = ptsPower;

EstimationParameters.kernel = kernel;
EstimationParameters.bandWidthValues = bw;
EstimationParameters.npoints = npoints;
EstimationParameters.function = typeOfFunction;
EstimationParameters.fsignal = frequency;

end