# Doc_rcpayload
En este repositorio se encuentra la documentación asociada a los experimentos RC a bordo de los satélites SUCHAI, así como los códigos utilizados para procesar y/o validar los datos que se reciban en forma de telemetría. 

*El experimento RC para SUCHAI 2 y 3 aún está en desarrollo, por lo que aún no contiene documentación*

# Suchai1: experimento RC
Resumen:

| Directorio | Descripción |
| ------ | ------ |
| matlab | Directorio raiz. |
| matlab/cutecom | Log de la consola serial del software del SUCHAI 1 donde se ejecutan los comandos **pay_print_seed (0x602C)** y **pay_testFreq_expFis(0x602D)** para las frecuencias que se quieren analizar.| 
| matlab/preprocessor | Archivos de texto plano (.txt) que contienen un parseo de los logs en el directorio *cutecom*.  |
| matlab/parser | Archivos de tipo Matlab (.mat) con structs que guardan la data dentro de los .txt que calzan con el formato usado en el directorio  *preprocesor*| 
| matlab/Builders | Scripts (.m) que construyen las series de tiempo, *vectores de tipo [voltage, tiempo]*, utilizadas en procesamientos posteriores. | 
| matlab/mat/ts | Time series generaada con la funcion **timeSeriesFactory**. Cada directorio interno contiene cuatro Mat-files asociados a un tipo de serie de tiempo. |

### matlab

### matlab/cutecom
Log de la consola serial del software del SUCHAI 1 donde se ejecutan los comandos **pay_print_seed (0x602C)** y **pay_testFreq_expFis(0x602D)** para las frecuencias que se quieren analizar.

  - ``parserTestFixture.log`` son las ejecuciones para adcPeriod={4,7,13,21,36,61,104, 175,295,498,840, 1417, 2389, 4029, 6793}. La version del firmware del experimento en ese momento contempla señales de un largo de 10.000 puntos.
  - El directorio `cutecom/2016_18_05` es la descomposicion en archivos logs independientes para cada comando (cada archivo contiene el print de la consola para un solo comando).

### matlab/Builder

| Script/Funcion | Descripción | Input | Output |
| ------ | ------ | ------ | ------ |
| pdfBuilder.m | Calcula la pdf de series de tiempo usando **ksdensity()**. Valroes ajustados para Suchai1. | **prefijo** de fecha de *FilteredSeries*, *ExpFisTimeSeries.tscData*, *SimulationFiltered* (datos experimentales) y *ExpFisTimeSeries.tscSimulation* (Simulink). | *ExpFisDistributions* (.mat) contiene las distribuciones de cada input. |
| payloadHistogram.m | Computa histcounts de las series de tiempo ExpFisTimeSeries | **prefijo** de fecha de los *ExpFisTimeSeries* | *ExpFisHistogram* (.mat) |
| payloadHistogramBigSimulation.m | calcula histcounts de archivos  | **prefijo** de fecha de los *${date}_Simulation_freq{index}.mat* | *SimulationHistogram.mat* |
| simulationTimeSeriesFilteredBuilder.m | Rescata los puntos de estado estacionario de la serie de tiempo a partir de una simulacion del circuito considerando los retardos del buffer. | Simulation (timeseries .mat) | *SimulationFiltered* (timeseries .mat) |

### timeSeriesFactory(freq, varargin)
Crea una collección de series de tiempo llamada `tsc` a partir de datos experimentas o parámetros de simulación. La collecion `tsc` contiene tres series de tiempo llamadas `vin`, `vout` e `injectedPower` que corresponden a las señales de voltaje entrada/salida y la potencia instantánea del circuito en el tiempo. El objeto de retorno de esta funcion es un *struct* que contiene esta collección junto a metadatos asociados a las series.


| Argumento | Descripción | 
| ------ | ------ |
| `freq` | Freqcuencia asociada la señal de entrada al circuito (en Hz) | 
| `varargin{1}` | String que indica el tipo de serie de tiempo a construir. Puede ser un string `'raw'` ,`'filtered'`, `'simulink'` o `'theoretical'` |

Tipos de series de tiempo:

  - **raw** Para el caso de datos experimentales, se utiliza un Mat-file que contenga el struct de las *cuentas*  generados por el RGN+DAC y medidas por el ADC. Usualmente varargin{1} es el struct generado por el parseo de la consola serial.
    - `varargin{2}: InputCounts` struct que contiene las cuentas digitales de 16 bits puestas a la entrada del circuito por el DAC. 
    - `varargin{3}: OutoutCounts` struct que contiene las cuentas digitales de 10 bits medidas a la salida del circuito por el ADC. 
  - **filtered** Genera una serie de tiempo subconjunto de la serie de tiempo de tipo **raw**. Este subconjunto corresponde a los datos de estado estacionario de la respuesta del circuito. Necesita los structs `InputCounts` y `OutoutCounts` generados por el parser.
    - `varargin{2}: InputCounts` struct que contiene las cuentas digitales de 16 bits puestas a la entrada del circuito por el DAC. 
    - `varargin{3}: OutoutCounts` struct que contiene las cuentas digitales de 10 bits medidas a la salida del circuito por el ADC. 
  - **simulink** Similar a las series de tiempo de tipo **raw**, pero el voltaje de salida `vout` no corresponde a las medidas tomadas por el ADC *in-situ* del experimento, sino que se generan con un modelo de Simulink del circuito. 
    - `varargin{2}: InputCounts` struct que contiene las cuentas digitales de 16 bits puestas a la entrada del circuito por el DAC. 
    - `varargin{3}` se interpreta como `oversamplingCoeff` (nivel de sobremuestreo).
  - **theoretical** Genera un series de tiempo 100% sintéticas, tanto para la entrada como la salida. La evolución temporal de las señales no considera que el almacenamiento de las muestras es instantáneo, por lo que no hay *delay's* asociados al traspaso buffer -> memoria SD.
    - `varargin{2}:`struct `Parameters`que contiene parámetros para construir las series de tiempo (frecuencia de la señal de entrada, tamaño (puntos) de la señal, niveles de voltaje, coeficiente de sobremuestreo y bits de conversion para el ADC/DAC).
    - `varargin{3}:`ninguno.

### payloadLinearFit 
Regresion lineal que calcula las constantes `(m,n)` asociadas al tiempo que dura un valor digital escrito por el DAC en segundos `(dTSignal = m*adcPeriod + n)`. La linealización utiliza las medidas que se encuentran en **payloadCSV.csv** las cuales fueron sacadas a mano en el laboratorio.

# Lista de archivos y directorios
- barwitherr.m
- Builders (directorio)
- computeFreqSignalHz.m
- computeHist.m
- count2voltage.m
- createVin.m
- createVout.m
- crossing.m
- cummean.m
- cutecom (directorio)
- doParser.m
- doPreProcessor.m
- doTimeSeriesFactory.m
- edgeGenerator.m
- filterCollection.m
- filterMemSDSimulation.m
- filterPayloadTimeSeries.m
- filterTimeSerie.m
- findSState.m
- findSStateSimple.m
- freqarray.m
- img (directorio)
- interpolateDataFromCounts.m
- kldiv.m
- linearFitValidation.m
- logPreProcessor.m
- makeExperimentalSeries.m
- makeSimulationSeries.m
- mat (directorio)
- nanReplace.m
- normalize.m
- parser (directorio)
- parserInput.m
- parserOutput.m
- payloadCommandValue.m
- payloadCSV.csv
- payloadLinearFit.m
- payloadModel.slx
- pdfEstimator.m
- Plotting (directorio)
- preprocessor (directorio)
- printBufferToFile.m
- processOneOutput.m
- randomNumberGenerator.m
- reconstructBufferedSignal.m
- repairZeros.m
- simulateSDtransfer.m
- simulateVout.m
- simulationFactory.m
- sortn.m
- testFilter.m
- testParser.m
- testPdfEstimator.m
- testPreProcessor.m
- testSDsimulation.m
- testTimeSeriesFactory.m
- timeSeriesFactory.m


