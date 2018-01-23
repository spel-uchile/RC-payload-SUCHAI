% This is a visual test to probe that the scripts works as it should
%% Test Lab data
% This test will use a laboratory adquired dataset
disp('Running test to laboratory telemetries ...');

disp('Preprocessing serial data ...');
testPreProcessor
disp('Preprocessing serial data ... complete');

disp('Parsing preprocessor text files ...');
testParser
disp('Parsing preprocessor text files ... complete');

disp('Building timeseries Mat-files from parser ...');
testTimeSeriesFactory
disp('Building timeseries Mat-files from parser ... complete');

disp('press ANY key to continue');
pause();

disp('Estimating PDF from timeseries ...');
testPdfEstimator
disp('Estimating PDF from timeseries ... complete');

disp('press ANY key to continue');
pause();

%% Test SUCHAI data
%The suchai dataset is very small so there it will strongly test the script
%But the PDF plots will look strange (thats normal due to the small
%dataset).
disp('Running test to SUCHAI telemetries ...');

disp('Preprocessing SUCHAI telemetry ...');
testPreProcessorSuchai
disp('Preprocessing SUCHAI telemetry ... complete');

disp('Parsing preprocessor text files ...');
testParser
disp('Parsing preprocessor text files ... complete');

disp('Building timeseries Mat-files from parser ...');
testTimeSeriesFactory
disp('Building timeseries Mat-files from parser ... complete');

disp('press ANY key to continue');
pause();

disp('Estimating PDF from timeseries ...');
testPdfEstimator
disp('Estimating PDF from timeseries ... complete');

disp('press ANY key to continue');
pause();