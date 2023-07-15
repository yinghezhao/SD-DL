function PreProcess_R2analyse_echo2(Parameter, tasks, run_matlabbatch)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_3D_Realigned = cell(Parameter.TotalTimepoints,1);
        dir_T1 = fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'anat');
        dir_T1raw = fullfile(dir_T1, ['sub-' subs{i} '_T1w.nii']);
        dir_func = fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'func');
        dir_Reference = fullfile(dir_func, ['meanasub-' subs{i} '_task-' tasks{taski} '_echo-2_bold_00001.nii']);
        dir_rp = fullfile(dir_func, ['rp_sub-' subs{i} '_task-' tasks{taski} '_echo-2_bold_00001.txt']);
        dir_phy = fullfile(dir_data, ['sub-' subs{i}], 'physio', 'multiple_regressors.txt');
        dir_model = fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'model');
        for ti = 1:Parameter.TotalTimepoints
            dir_ra = [fullfile(dir_func, ['rasub-' subs{i} '_task-' tasks{taski} '_echo-2_bold_' num2str(ti,'%05d') '.nii']) ',1'];
            dir_3D_Realigned{ti,1} = dir_ra;
        end
        if Parameter.use_phy == 0
            multi_reg = {dir_rp};
        elseif Parameter.use_phy == 1
            multi_reg = {dir_rp; dir_phy};
        end
        matlabbatch = Batch_PreProcess_R2analyse_echo2(dir_Reference, dir_T1raw, dir_3D_Realigned,dir_model, multi_reg);
        spm('defaults', 'FMRI');
        if run_matlabbatch == 1
            spm_jobman('run', matlabbatch);
            utils_DeleteTempFiles(dir_T1,'T1',Parameter.DelTempFiles);
            utils_DeleteTempFiles(dir_func,'func',Parameter.DelTempFiles);
        end
    end
end
disp(['Finished PreProcess_R2analyse_echo2!']);
end