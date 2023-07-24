function PreProcess_4DR2analyse(Parameter, tasks, modality, run_matlabbatch)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_phy = fullfile(dir_data, ['sub-' subs{i}], 'physio', 'multiple_regressors.txt');
        for modali = 1:length(modality)
            dir_mod = fullfile(dir_data, ['sub-' subs{i}], modality{modali});
%             dir_T1 = [dir_mod '\anat'];
%             dir_T1raw = [dir_T1 '\sub-' subs{i} '_T1w.nii'];
            dir_func = fullfile(dir_mod, 'func');
            if exist(fullfile(dir_func, '4D_Realigned.nii.gz'))
                gunzip(fullfile(dir_func, '4D_Realigned.nii.gz'));
            end
            dir_4D_modeldata = fullfile(dir_func, '4D_Realigned.nii');
            dir_rp = fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'func', ['rp_sub-' subs{i} '_task-' tasks{taski} '_echo-2_bold_00001.txt']);
            dir_model = fullfile(dir_mod, 'model');
            if Parameter.use_phy == 0
                multi_reg = {dir_rp};
            elseif Parameter.use_phy == 1
                multi_reg = {dir_rp; dir_phy};
            end
            matlabbatch = Batch_PreProcess_4DR2analyse(dir_func, dir_4D_modeldata,dir_model,multi_reg);
            spm('defaults', 'FMRI');
            if run_matlabbatch == 1
                spm_jobman('run', matlabbatch);
                utils_DeleteTempFiles(dir_func,'func',Parameter.DelTempFiles);
            end
        end
    end
end
disp(['Finished PreProcess_4DR2analyse!']);
end