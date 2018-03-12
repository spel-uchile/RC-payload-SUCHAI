Pseudo code that describes the execution in each log file:
File: "2016_18_05_freq{index}.log"
	FIS_POINTS=1000
	FIS_SAMPLES=40000
	buffer = 400
	oversampling=4
	opcion1+3 = no
	seed = {0}
	freq = {4, 7, 13, 21, 36, 61, 104, 175, 295, 498, 840, 1417, 2389, 4029, 6793}
	for index = 0 : 14
		pay_conf_expFis(freq[index]);
        	pay_exec_expFis(0);
	end


File: "2016_18_05_input_voltages.log"
	FIS_POINTS=1000
	seed = {0}
	pay_print_seed();



