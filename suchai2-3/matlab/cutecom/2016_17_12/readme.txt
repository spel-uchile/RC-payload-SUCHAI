Pseudo code that describes the execution in each log file:
File: "2016_17_12.log"
	FIS_POINTS=100
	FIS_SAMPLES=400
	oversampling=4
	buffer = 400
	opcion1+3 = yes
	for adcPeriod = {4029, 6793}
		for seed = {0, 1000, 5000}
		    pay_set_adcPeriod_expFis(adcPeriod);
		    pay_set_seed_expFis(seed);
		    pay_conf_data_repo_expFis();
		    pay_exec_expFis();
		end
	end

