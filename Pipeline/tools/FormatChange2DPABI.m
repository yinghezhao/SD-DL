function FormatChange2DPABI(Parameter,tasks,modality)
subs = Parameter.subs;
filename = '4D_Realigned.nii';

for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_root,tasks{taski});
    dir_task_dpabi = fullfile(Parameter.dir_DPABI,tasks{taski});
    if ~exist(dir_task_dpabi,'dir')
        mkdir(dir_task_dpabi);
    end
    for modali = 1:length(modality)
        dir_modal_dpabi = fullfile(dir_task_dpabi,modality{modali});
        if ~exist(dir_modal_dpabi,'dir')
            mkdir(dir_modal_dpabi);
            mkdir(fullfile(dir_modal_dpabi,'FunImgAR'));
            mkdir(dir_modal_dpabi,'T1Img');
        end
        dir_rp_dpabi = fullfile(dir_modal_dpabi, 'RealignParameter');
        if ~exist(dir_rp_dpabi,'dir')
            mkdir(dir_rp_dpabi);
        end
        
        for subi = 1:length(subs)
            dir_sub_dpabi_Fun = fullfile(dir_modal_dpabi, 'FunImgAR', ['sub-' subs{subi}]);
            if ~exist(dir_sub_dpabi_Fun,'dir')
                mkdir(dir_sub_dpabi_Fun);
            end
            dir_sub_dpabi_T1 = fullfile(dir_modal_dpabi, 'T1Img', ['sub-' subs{subi}]);
            if ~exist(dir_sub_dpabi_T1,'dir')
                mkdir(dir_sub_dpabi_T1);
            end
            dir_sub_dpabi_ReaPara = fullfile(dir_rp_dpabi, ['sub-' subs{subi}]);
            if ~exist(dir_sub_dpabi_ReaPara,'dir')
                mkdir(dir_sub_dpabi_ReaPara);
            end
            dir_sub = fullfile(dir_task, ['sub-' subs{subi}]);
            dir_modal = fullfile(dir_sub, modality{modali});
            dir_T1 = fullfile(dir_modal,'anat');
            dir_T1_file = fullfile(dir_T1, ['sub-' subs{subi} '_T1w.nii']);
            dir_Fun = fullfile(dir_modal,'func');
            dir_Fun_file = fullfile(dir_Fun,filename);
            
            % copyfiles
            if isequal(modality{modali}, 'echo2')
                copyfile(dir_T1_file, dir_sub_dpabi_T1);
            else
                copyfile( fullfile(dir_sub,'echo2','anat',['sub-' subs{subi} '_T1w.nii']), dir_sub_dpabi_T1);
            end
            
            copyfile(dir_Fun_file, dir_sub_dpabi_Fun);
            
            dir_rp = fullfile(dir_sub,'echo2','func',['rp_sub-' subs{subi} '_task-' tasks{taski} '_echo-2_bold_00001.txt']);
            copyfile(dir_rp, dir_sub_dpabi_ReaPara);
            
        end
    end
end
disp('Finished FormatChange2DPABI');
end
