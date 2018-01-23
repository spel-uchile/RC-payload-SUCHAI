# RC-payload-SUCHAI
This repository contains mainly the processing tools used in Physics Experiment of the SUCHAI 1 project (also a little of SUCHAI 2/3). Also contains the firmware onboard of SUCHAI and the processing scripts for the downloaded telemetry, that were used to compare the results between space and earth measurements.

This repository was developed mainly in the MATLAB IDE, so it could be easily integrated for other students or academics.

## Prerequisites
The scripts and functions were developed in the Matlab enviroment. The minimun versions of the IDE are. Any new version of MATLAB IDE should work too:
```
Matlab 8.5.0.197613 (R2015a)
Simulink 8.5
```

To get telemetry data from the SUCHAI replica inside the Pumpkin Development Board, you need to have a Serial Terminal. In Linux I use [CuteCom](http://cutecom.sourceforge.net/), but in Windows i like [CoolTerm](http://freeware.the-meiers.org/):
```
Cutecom (or any Serial Terminal for Linux)
CoolTerm (or any Serial Terminal for Windows)
```
## Getting Started

Go to the directory `suchai1/matlab` where there are all the scripts to generate MAT-files with the time series and probability functions of the RC experiment aboard SUCHAI 1.

```
cd $YOUR_REPOSITORY_DIRECTORY_NAME$/suchai1/matlab
```

### Running the tests
The folder `matlab/logs/test/` contains test fixtures (emulating lab and satellite logs). These logs files are expected to be used with the scripts `test*.m` and the output generated are stored in `suchai1/matlab/mat/ts/test/` (timeseries) and in `suchai1/matlab/mat/pdf/test/` (probability density functions). The output files are stored aa MAT-files (v7.3) and can be used to further analysis or graphs.

#### To run all test at once
```
>> runAllTest
```

## Running the scripts
The folder `matlab/logs/` contains logs files from the laboratory (`/lab`) and from SUCHAI (`/suchai`). These logs files are expected to be used with the scripts `do*.m` and the output generated are stored in `suchai1/matlab/mat/ts/` (timeseries) and in `suchai1/matlab/mat/pdf/test` (probability density functions). The output files are stored aa MAT-files (v7.3) and can be used to further analysis or graphs.

### When running for the first time
When running for the first time uncommnet the values in the script, as below:
```
%% when running for the first time uncommnet this values
% prefix = '2016_18_05';
% dataset = 'lab';
```
Then run the script in the Matlab console:
```
>> doProcessOneLogCompletly
```
### When processing a new telemetry
When processing a new telemetry change the values of 'prefix' and 'dataset' to the corresponding values. For example, the log text "SUCHAI_20180111_125344.txt" should be processed with this values:
```
% Example of use with a real telemetry
prefix = '2018_01_11_125344';
dataset = 'suchai';
```
Then run the script in the Matlab console:
```
>> doProcessOneLogCompletly
```
## Plotting the data
To generate one graph of the probability density function (PDF) per each frequency just run this script in the matlab console:
```
>> doPlotEachFrequency
```

To plot a specific PDF inside `suchai1/matlab/mat/pdf` folder use `doPlotOnePDF.m`.

To plot a specific time series inside `suchai1/matlab/mat/ts` folder use `doPlotOneTimeSeries.m`

Every graph generated should be stored in `suchai1/matlab/img/` folder.

## Contact

Use the [issue tracker](https://github.com/spel-uchile/RC-payload-SUCHAI/issues) to submit questions, requirements and bugs.

Follow [SPEL team](https://twitter.com/SPEL_UCHILE) at Twitter to get latest news about SUCHAI project.
