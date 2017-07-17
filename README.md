# README
This repository contains the Latex files of the documentation associated with the RC experiement on board of SUCHAI satellites. Separate files for SUCHAI 1 and SUCHAI 2/3 experiments.

# Suchai1: experimento RC
Resumen:

| Directorio | Descripción |
| ------ | ------ |
| matlab | Directorio raiz. |
| matlab/cutecom | Log de la consola serial del software del SUCHAI 1 donde se ejecutan los comandos **pay_print_seed (0x602C)** y **pay_testFreq_expFis(0x602D)** para las frecuencias que se quieren analizar.| 
| matlab/preprocessor | Archivos de texto plano (.txt) que contienen un parseo de los logs en el directorio *cutecom*.  |
| matlab/parser | Archivos de tipo Matlab (.mat) con structs que guardan la data dentro de los .txt que calzan con el formato usado en el directorio  *preprocesor*| 
| matlab/Builders | Scripts (.m) que construyen las series de tiempo, *vectores de tipo [voltage, tiempo]*, utilizadas en procesamientos posteriores. | 

### matlab

*payloadLinearFit* regresion lineal dTSignal = m*adcPeriod + n

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

