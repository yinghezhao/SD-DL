function CopyModelFiles(Parameter,tasks,modality)
subs = Parameter.subs;
for taski = 1:length(tasks)
    for subi = 1:length(subs)
        if ~exist(fullfile(Parameter.dir_root, tasks{taski}, ['sub-' subs{subi}]),'dir')
            mkdir(fullfile(Parameter.dir_root, tasks{taski}, ['sub-' subs{subi}]));
        end
        for modali = 1:length(modality)
            dir_source = fullfile(Parameter.dir_model_source, tasks{taski}, modality{modali}, 'Reshaped', 't2s');
            dir_des = fullfile(Parameter.dir_root,tasks{taski},['sub-' subs{subi}],modality{modali});
            if ~exist(dir_des,'dir')
                mkdir(dir_des);
                mkdir(fullfile(dir_des, 'func'));
                mkdir(fullfile(dir_des, 'model'));
            end
            file_model = fullfile(dir_des, 'func', '4D_Realigned.nii');
            if ~exist(file_model,'file')
                dir_echo2 = fullfile(Parameter.dir_root, tasks{taski}, ['sub-' subs{subi}], 'echo2', 'func', ['sub-' subs{subi} '_task-' tasks{taski} '_echo-2_bold.nii']);
                dir_model_mat_t2s = fullfile(dir_source, ['sub-' subs{subi} '_task-' tasks{taski} '.mat']);
                t2s_model = importdata(dir_model_mat_t2s);
                t2s_model(t2s_model > 1) = 1;
                t2s_model(t2s_model < 0) = 0;
                nii_echo2 = load_nii(dir_echo2);
                info_hdr = nii_echo2.hdr;
                nii_model = make_nii(t2s_model, Parameter.VoxelSize, [0 0 0], Parameter.datatype);
                nii_model.hdr.hist = info_hdr.hist;
                save_nii(nii_model, file_model);
            end
        end
    end
end
disp('Finished CopyModelFiles!');
end