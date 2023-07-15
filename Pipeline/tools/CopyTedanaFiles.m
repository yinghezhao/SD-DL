function CopyTedanaFiles(Parameter, tasks,replace, modality)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_sub = fullfile(dir_task, ['sub-' subs{i}]);
        dir_echo2_Realigned = fullfile(dir_sub, 'echo2', 'func', '4D_Realigned.nii');
        if replace == 0
            dir_OC = fullfile(dir_sub, 'OC');
            dir_MEICA = fullfile(dir_sub, 'MEICA');
            utils_CopyTedanaFiles(dir_echo2_Realigned,dir_OC,dir_MEICA);
        elseif replace == 1
            if ~isempty(modality)
                for modali = 1:length(modality)
                    dir_OC = fullfile(dir_sub, ['OC_' modality{modali}]);
                    dir_MEICA = fullfile(dir_sub, ['MEICA_' modality{modali}]);
                    utils_CopyTedanaFiles(dir_echo2_Realigned,dir_OC,dir_MEICA);
                end
            end
        end
    end
end
disp(['Finished CopyTedanaFiles!']);
end