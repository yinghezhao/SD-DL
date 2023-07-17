clear;
clc;

Parameter = ParameterConfig();
task_states = {'fingerTapping'};
rest_states = {'rest_run-1','rest_run-2'};
tasks_all = cat(2,task_states,rest_states);

modality1 = {'echo2'};
modality2 = {'t2star_2','t2star_3', 'TEcom'};
modality3 = {'OC','MEICA'};
model_name = {'Unet_t2s_rician_3p'};
replacename = {['OC_' model_name{1}],['MEICA_' model_name{1}]};

modality_wo_mod = cat(2,modality1,modality2,modality3,replacename);
modality_all = cat(2,modality1,modality2,modality3,model_name,replacename);

% ---------------------------------
Cal_ROI(Parameter, task_states, modality_all);
ComparisonMetrics(Parameter, task_states, modality_all);

CalculateTSNR(Parameter,rest_states(1), modality_wo_mod, model_name);