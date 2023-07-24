function CatData(Parameter,tasks,replace,modality)
subs = Parameter.subs;
if replace == 0
    suffix_ave = '';
elseif replace == 1
    suffix_ave = ['_' modality{1}];
end

for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_sub = fullfile(dir_task, ['sub-' subs{i}]);
        dir_OC = fullfile(dir_sub, ['OC' suffix_ave]);
        dir_MEICA = fullfile(dir_sub, ['MEICA' suffix_ave]);
%         
        if exist(fullfile(dir_sub, ['\OC' suffix_ave]))
            eval(['!rename',[',' fullfile(dir_sub, ['\OC' suffix_ave]) ','], [',' fullfile(dir_sub, ['OC' suffix_ave]) ',']]);
%             rmdir(fullfile(dir_sub, ['\OC' suffix_ave]),'s');
        end
        if exist(fullfile(dir_sub, ['\MEICA' suffix_ave]))
            eval(['!rename',[',' fullfile(dir_sub, ['\MEICA' suffix_ave]) ','], [',' fullfile(dir_sub, ['MEICA' suffix_ave]) ',']]);
%             rmdir(fullfile(dir_sub, ['\MEICA' suffix_ave]),'s');
        end
%         
        if ~exist(dir_OC)
            mkdir(dir_OC);
            mkdir(fullfile(dir_OC, 'func'));
            mkdir(fullfile(dir_OC, 'model'));
        end
        if ~exist(dir_MEICA)
            mkdir(dir_MEICA);
            mkdir(fullfile(dir_MEICA, 'func'));
            mkdir(fullfile(dir_MEICA, 'model'));
        end
        if ~ exist(fullfile(dir_MEICA, 'tedana_output'))
            mkdir(fullfile(dir_MEICA, 'tedana_output'));
        end
        save_name = fullfile(dir_MEICA, 'cat_echo123.nii');
        if exist([save_name '.gz']) && replace == 0
            disp(['pass ' save_name]);
            continue;
        elseif exist([save_name '.gz']) && exist(fullfile(dir_MEICA, 'tedana_output','t2s.nii')) && replace == 1 
            disp(['pass ' save_name]);
            continue;
        end
        % cat data
        for e = 1:3
            dir_echo_Realigned = fullfile(dir_sub, ['echo' num2str(e)], 'func', '4D_Realigned.nii');
            niifile = load_nii(dir_echo_Realigned);
            func_Realigned(:,:,:,:,e) = double(niifile.img);
        end
        [nx, ny, nz, nt, ne] = size(func_Realigned);
        cat_data = zeros(nx, ny, nz*ne, nt);
        cat_data(:,:,1:nz,:) = func_Realigned(:,:,:,:,1);
        cat_data(:,:,nz+1:2*nz,:) = func_Realigned(:,:,:,:,2);
        cat_data(:,:,2*nz+1:3*nz,:) = func_Realigned(:,:,:,:,3);
        catnii = make_nii(cat_data,[],[],Parameter.datatype);
        
        save_nii(catnii,save_name);
        
        gzip(save_name,dir_MEICA);
        if exist([save_name '.gz']) && exist(save_name)
            delete(save_name);
        end
        disp(['saved ' save_name]);
        
        if replace == 1
            dir_data_replace = fullfile(Parameter.dir_model_source,'Average', tasks{taski}, modality{1},'Reshaped','t2s');
            dir_sub_replace = fullfile(dir_data_replace, ['sub-' subs{i} '_task-' tasks{taski} '.mat']);
            dir_mask = fullfile(dir_sub, 'mask.mat');
            data_replace = importdata(dir_sub_replace);
            data_mask = rot90(importdata(dir_mask),3);
            data_replace = data_replace .* data_mask;
            nii_replace = make_nii(data_replace,[],[],Parameter.datatype);
            replace_name = fullfile(dir_MEICA, 'tedana_output','t2s.nii');
            save_nii(nii_replace,replace_name);
            gzip(replace_name,fullfile(dir_MEICA, 'tedana_output'));
        end
    end
end
disp(['Finished CatData!']);
end