clear;
clc;

Parameter = ParameterConfig();

task_states = {'fingerTapping'};
rest_states = {'rest_run-1','rest_run-2'};
tasks_all = cat(2,task_states,rest_states);

modality1 = {'echo2'};
modality2 = {'t2star_2','t2star_3', 'TEcom'};
modality3 = {'OC','MEICA'};
modality_cat123 = cat(2,modality1,modality2,modality3);

run_matlabbatch = 1;

% ---------------------------------
CopyFiles(Parameter, tasks_all);
Preprocess_SR_3echoes(Parameter, tasks_all, run_matlabbatch);

PreProcess_TAPAS_physio(Parameter, task_states,run_matlabbatch);
% ---------------------------------
% PreProcess_R2analyse_echo2(Parameter, tasks_all, run_matlabbatch); % useless 

Echo22Mask(Parameter,tasks_all);

Cal_Realigned(Parameter, tasks_all, modality2);
% ---------------------------------
CatData(Parameter,tasks_all,0,'');
% RunTedata(Parameter,tasks_all,0,modality3(2)); %  useless
CopyTedanaFiles(Parameter,tasks_all,0,'');
% ---------------------------------
ARechoes2Normed2d(Parameter, tasks_all);
ARechoes2Normed2d_average(Parameter, tasks_all);
% ---------------------------------
PreProcess_4DR2analyse(Parameter, task_states, modality_cat123, run_matlabbatch);
