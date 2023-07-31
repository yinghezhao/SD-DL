clear;
clc;

Parameter = ParameterConfig();
rest_states = {'rest_run-1','rest_run-2'};
modality = {'MEICA','MEICA_Unet_t2s_9_rician_3p'};

% ------------proprocess------------
% FormatChange2DPABI(Parameter,rest_states,modility);
% Remember to manually run dpabi process before the following analyse.

% ExtractROI(Parameter,{});
% Cal_FC(Parameter,rest_states,modality);
% Dice = Cal_Dice(Parameter,modality,0.4);
Dice_coff = analyse_FCM(Parameter, rest_states, modality);


