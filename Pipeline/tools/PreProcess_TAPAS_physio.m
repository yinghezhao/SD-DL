function PreProcess_TAPAS_physio(Parameter,tasks,run_matlabbatch)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_source_physio = fullfile(Parameter.dir_source, ['sub-' subs{i}], 'func');
        name_phy_json = ['sub-' subs{i} '_task-' tasks{taski} '_physio.json'];
        name_phy_tsv = ['sub-' subs{i} '_task-' tasks{taski} '_physio.tsv.gz'];
        dir_sub = fullfile(dir_data, ['sub-' subs{i}]);
        save_dir = fullfile(dir_sub, 'physio');
        file_physio_json = [save_dir name_phy_json];
        file_physio_tsv = [save_dir name_phy_tsv];
        if ~exist(fullfile(dir_sub, 'physio'),'dir')
            mkdir(fullfile(dir_sub, 'physio'));
        end
        if ~exist(file_physio_json)
            copyfile(fullfile(dir_source_physio, name_phy_json),file_physio_json);
        end
        if ~exist(file_physio_tsv)
            copyfile(fullfile(dir_source_physio, name_phy_tsv),file_physio_tsv);
        end
        matlabbatch = Batch_PreProcess_TAPAS_physio(save_dir, file_physio_tsv);
        spm('defaults', 'FMRI');
        if run_matlabbatch == 1
            spm_jobman('run', matlabbatch);
        end
    end
end
disp(['Finished PreProcess_TAPTAS_physio!']);
end