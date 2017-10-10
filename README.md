# RC-payload-SUCHAI
This repository has the software used in the RC payload in SUCHAI projects (SUCHAI1 and SUCHAI 2/3). This contains the firmware onboard of SUCHAI and the data processing scripts of the telemetry, that were used to compare the results between space and earth measurements..

*The experiment for SUCHAI 2/3 is not developed yet, so only simulation scripts are provided.*

## Getting Started

Go to `suchai1/matlab` where there are all the scripts to generate MAT-files with the time series and probability functions of the RC experiment aboard SUCHAI 1.

## Prerequisites
The scripts and functions were developed in the Matlab enviroment. The specific versions of these are:
```
Matlab 8.5.0.197613 (R2015a)
Simulink 8.5
Cutecom (or any Serial Terminal)
```
It should work with newer Matlab/Simulink versions.
## Installing 
Not needed! Just open your Matlab version and run the scripts!.

## Running the tests
The folder `matlab/logs/test` contains test data (emulating lab and satellite). These logs files are expected to be used with the scripts `testPreProcessor.m `(lab only), ` testParser.m, testPreProcessorSuchai.m `(suchai only), `testTimeSeriesFactory.m, testPdfEstimator.m, testSDsimulation.m` and others (all `test*.m` files). If you can run the chain  preprocessor>Parser>timeseriesFactory>PdfEstimator then you are ready to process the real Suchai 

## Running the scripts
The folder`matlab/logs/suchai` contains the raw frames with the data collected by the satellite, and  `matlab/logs/lab` contains the data generated with a satellite replica inside the laboratory. These dataset is expected to be used with the scripts `doPreProcessor.m`(lab only), `doParser.m, doPreProcessorSuchai.m `(suchai telemetry only), `testTimeSeriesFactory.m, testPdfEstimator.m` and others (aka all `test*.m` files).




