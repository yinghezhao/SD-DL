function RunTedata(Parameter,tasks,replace,modality)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_sub = fullfile(dir_task, ['sub-' subs{i}]);
        for modali = 1:length(modality)
            dir_file = fullfile(dir_sub, modality{modali}, 'cat_echo123.nii.gz');
            dir_output = fullfile(dir_sub,modality{modali}, 'tedana_output');
            dir_t2s = fullfile(dir_output, 't2s.nii');
            if replace == 0
                command = ['tedana -e ' num2str(Parameter.TE,'% d') ' -d ' dir_file ' --out-dir ' dir_output];
            elseif replace == 1
                command = ['tedana -e ' num2str(Parameter.TE,'% d') ' -d ' dir_file ' --out-dir ' dir_output ' --t2smap ' dir_t2s];
            end
            system(command);
        end
    end
end

disp(['Finished RunTedata!']);
end