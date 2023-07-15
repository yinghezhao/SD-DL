function CopyFiles(Parameter, tasks)
subs = Parameter.subs;
for taski = 1:length(tasks)
    dir_des = fullfile(Parameter.dir_root, tasks{taski});
    if~exist(dir_des)
        mkdir(dir_des);
    end
    for i = 1:length(subs)
        dir_T1 = fullfile(Parameter.dir_source, ['sub-' subs{i}], 'anat', ['sub-' subs{i} '_T1w.nii']);
        for e = 1:3
            dir_fun = fullfile(Parameter.dir_source, ['sub-' subs{i}], 'func', ['sub-' subs{i} '_task-' tasks{taski} '_echo-' num2str(e) '_bold.nii']);
            dir_des_T1 = fullfile(dir_des, ['sub-' subs{i}], ['echo' num2str(e)], 'anat');
            dir_des_fun = fullfile(dir_des, ['sub-' subs{i}], ['echo' num2str(e)], 'func');
            if~exist(dir_des_T1)
                mkdir(dir_des_T1);
            end
            status = copyfile(dir_T1,dir_des_T1);
            if status == 0
                disp(['Failed copy files: ' tasks{taski} '-' subs{i} '-echo' num2str(e) ' T1 files']);
            end
            if~exist(dir_des_fun)
                mkdir(dir_des_fun);
            end
            status = copyfile(dir_fun,dir_des_fun);
            if status == 0
                disp(['Failed copy files: ' tasks{taski} '-' subs{i} '-echo' num2str(e) ' func files']);
            end
            dir_des_model = fullfile(dir_des, ['sub-' subs{i}], ['echo' num2str(e)], 'model');
            if~exist(dir_des_model)
                mkdir(dir_des_model);
            end
        end
    end
end
disp(['Finished CopyFiles!']);
end