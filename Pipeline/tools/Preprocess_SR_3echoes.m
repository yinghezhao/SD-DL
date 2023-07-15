function Preprocess_SR_3echoes(Parameter, tasks, run_matlabbatch)
% run_matlabbatch: 1 - run preprocessing
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_func1 = fullfile(dir_data, ['sub-' subs{i}], 'echo1', 'func');
        dir_funcraw1 = fullfile(dir_func1, ['sub-' subs{i} '_task-' tasks{taski} '_echo-1_bold.nii']);
        dir_func2 = fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'func');
        dir_funcraw2 = fullfile(dir_func2, ['sub-' subs{i} '_task-' tasks{taski} '_echo-1_bold.nii']);
        dir_func3 = fullfile(dir_data, ['sub-' subs{i}], 'echo3', 'func');
        dir_funcraw3 = fullfile(dir_func3, ['sub-' subs{i} '_task-' tasks{taski} '_echo-1_bold.nii']);
        
        matlabbatch = Batch_PreProcess_SR_3echoes(dir_funcraw1, dir_func1, dir_funcraw2, dir_func2, dir_funcraw3, dir_func3);
        spm('defaults', 'FMRI');
        if run_matlabbatch == 1
            spm_jobman('run', matlabbatch);
        end
        
        utils_DeleteTempFiles(dir_func1,'func',Parameter.DelTempFiles);
        utils_DeleteTempFiles(dir_func3,'func',Parameter.DelTempFiles);
        
        if Parameter.DelTempFiles && exist(fullfile(dir_data, ['sub-' subs{i}], 'echo1', 'anat', ['sub-' subs{i} '_T1w.nii']))
            delete(fullfile(dir_data, ['sub-' subs{i}], 'echo1', 'anat', ['sub-' subs{i} '_T1w.nii']));
        end
        if Parameter.DelTempFiles && exist(fullfile(dir_data, ['sub-' subs{i}], 'echo3', 'anat', ['sub-' subs{i} '_T1w.nii']))
            delete(fullfile(dir_data, ['sub-' subs{i}], 'echo3', 'anat', ['sub-' subs{i} '_T1w.nii']));
        end
    end
end

disp(['Finished Preprocess_SR_3echoes!']);

end