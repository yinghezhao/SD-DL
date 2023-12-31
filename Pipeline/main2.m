clear;
clc;

Parameter = ParameterConfig();
task_states = {'fingerTapping'};
rest_states = {'rest_run-1','rest_run-2'};
tasks_all = cat(2,task_states,rest_states);

model_name = {'Unet_t2s_rician_3p'};
replacename = {['OC_' model_name{1}],['MEICA_' model_name{1}]};
catnames = cat(2,model_name,replacename);

run_matlabbatch = 1;

% ---------------------------------
CopyModelFiles(Parameter,tasks_all,model_name);

CatData(Parameter,tasks_all,1,model_name);
%  Before running the 'CopyTedanaFiles' function below, please run the 'RunTedana.py' file under Unet_T2Mapping folder.
CopyTedanaFiles(Parameter, tasks_all,1, model_name);

PreProcess_4DR2analyse(Parameter, task_states, catnames, run_matlabbatch);