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
Not needed (?) Just open your Matlab IDE and run the scripts (see *Running the tests*).

## Running the tests
The folder `matlab/logs/test/` contains test fixtures (emulating lab and satellite logs). These logs files are expected to be used with the scripts `test*.m` and the output generated are stored in `suchai1/matlab/mat/ts/test/` (timeseries) and in `suchai1/matlab/mat/pdf/test/` (probability density functions). The output files are stored aa MAT-files (v7.3) and can be used to further analysis or graphs.
#### Lab Logs
```
>> testPreProcessor
>> testParser
>> testTimeSeriesFactory
>> testPdfEstimator
```
#### Suchai Logs
```
>> testPreProcessorSuchai
>> testParser
>> testTimeSeriesFactory
>> testPdfEstimator
```

## Running the scripts
The folder `matlab/logs/` contains logs files from the laboratory (`/lab`) and from SUCHAI (`/suchai`). These logs files are expected to be used with the scripts `do*.m` and the output generated are stored in `suchai1/matlab/mat/ts/` (timeseries) and in `suchai1/matlab/mat/pdf/test` (probability density functions). The output files are stored aa MAT-files (v7.3) and can be used to further analysis or graphs.
#### Lab Logs
```
>> doPreProcessor
>> doParser
>> doTimeSeriesFactory
>> doPdfEstimator
```
#### Suchai Logs
```
>> doPreProcessorSuchaiLogs
>> doParser
>> doTimeSeriesFactory
>> doPdfEstimator
```

## Plotting the data
To generate one graph of the probability density function (PDF) per each frequency.
```
>> doPlotEachFrequency
```

To generate one graph of the PDFs of all the frequencies.
```
>> doPlotAllTelemetries
```

To plot a specific PDF inside `suchai1/matlab/mat/pdf` folder use `doPlotOnePDF.m`.

To plot a specific PDF inside `suchai1/matlab/mat/ts` folder use `doPlotOneTimeSeries.m`

Every graph generated should be stored in `suchai1/matlab/img/` folder.

## Contact

Use the [issue tracker](https://github.com/spel-uchile/RC-payload-SUCHAI/issues) to submit questions, requirements and bugs.

Follow [SPEL team](https://twitter.com/SPEL_UCHILE) at Twitter to get latest news about SUCHAI project.
