function tSNR_modality = CalculateTSNR(Parameter,tasks, modality, modelname)
subs = Parameter.subs;
save_name = 'tSNR_model_AR.mat';
fields = [modality, modelname];
for taski = 1:length(tasks)
    disp(['start calculate '  tasks{taski} ' tSNR......']);
    dir_task = fullfile(Parameter.dir_root, tasks{taski});
    dir_model_task = fullfile(Parameter.dir_model_source, tasks{taski});
    dir_modality = cell(1);
    tSNR_modality = cell(1);
    for subi = 1:length(subs)
        disp(['start calculate sub-'  subs{subi} ' tSNR......']);
        dir_mask = fullfile(dir_task, ['sub-' subs{subi}], 'mask.mat');
        mask = importdata(dir_mask);
        mask_voxels = sum(sum(sum(mask)));
        for methodi = 1:length(modality)
            dir_method = fullfile(dir_task, ['sub-' subs{subi}], modality{methodi});
            dir_modality{methodi} = fullfile(dir_method, 'func', '4D_Realigned.nii');
            masked_tSNR = mask .* rot90(utils_Cal_tSNR(dir_modality{methodi},[Parameter.CalTSNRTimePeriod(1),Parameter.CalTSNRTimePeriod(2)]));
            masked_tSNR(find(isnan(masked_tSNR))) = 0;
            mean_tSNR = sum(sum(sum(masked_tSNR))) / mask_voxels;
            tSNR_modality{subi,methodi} = mean_tSNR;
        end
        if ~isempty(modelname) 
            for modeli = 1:length(modelname)
                dir_model = fullfile(dir_model_task, modelname{modeli}, 'Reshaped', 't2s');
                dir_modality{length(modelname)+modeli} = fullfile(dir_model, ['sub-' subs{subi} '_task-' tasks{taski} '.mat']);
                
                masked_tSNR = mask .* rot90(utils_Cal_tSNR(dir_modality{length(modelname)+modeli},[Parameter.CalTSNRTimePeriod(1),Parameter.CalTSNRTimePeriod(2)]));
                masked_tSNR(find(isnan(masked_tSNR))) = 0;
                mean_tSNR = sum(sum(sum(masked_tSNR))) / mask_voxels;
                
                tSNR_modality{subi,length(modality)+modeli} = mean_tSNR;
            end
        end
    end
    tSNR_modalities = cell2struct(tSNR_modality,fields,2);
    dir_save_tSNR = fullfile(Parameter.dir_result, tasks{taski},save_name);
    if ~exist(fullfile(Parameter.dir_result, tasks{taski}),'dir')
        mkdir(fullfile(Parameter.dir_result, tasks{taski}));
    end
    if ~exist(dir_save_tSNR,'file')
        save(dir_save_tSNR,'tSNR_modalities');
    else
        warning([dir_save_tSNR ' exists, original file will not be overwritten ']);
    end
    
end

disp('Finished CalculateTSNR!');
end