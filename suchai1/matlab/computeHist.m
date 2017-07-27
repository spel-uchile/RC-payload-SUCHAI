clear all;
close all;

date = '2016_18_05';
prefix = strcat(date,'_');
saveFolder = strcat('./img/',date,'/');
bins = 50;
histogramFileName = strcat(prefix, 'ExpFisHistogram.mat');

if ~exist(histogramFileName,'file')
    histogramFileName = payloadHistogram(prefix, bins);
end