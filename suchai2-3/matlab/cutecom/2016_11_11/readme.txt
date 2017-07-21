Pseudo code that describes the execution in each log file:
File: "2016_11_11.log"
	FIS_POINTS=16000
	FIS_SAMPLES=64000
	buffer = 400
	oversampling=4
	opcion1+3 = yes
	for adcPeriod = {4, 7, 13, 21, 36, 61, 104, 175, 295, 498, 840, 1417, 2389}
		for seed = {0, 1000, 5000}
		    pay_set_adcPeriod_expFis(adcPeriod);
		    pay_set_seed_expFis(seed);
		    pay_conf_data_repo_expFis();
		    pay_exec_expFis();
		end
	end

