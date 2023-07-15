function ARechoes2Normed2d(Parameter, tasks)
subs = Parameter.subs;
Nx = Parameter.VoxelNumber(1);
Ny = Parameter.VoxelNumber(2);
Nz = Parameter.VoxelNumber(3);
Nt = Parameter.TotalTimepoints;
Ne = length(Parameter.TE);
for taski = 1:length(tasks)
    dir_source_task = fullfile(Parameter.dir_root, tasks{taski});
    dir_tasks = fullfile(Parameter.dir_Normed, tasks{taski});
    if ~exist(dir_tasks, 'dir')
        mkdir(dir_tasks);
    end
    for i = 1:length(subs)
        data_sub_echo123 = zeros(Nx, Ny, Nz, Nt, Ne);
        for e = 1:length(Parameter.TE)
            dir_sub_echo = fullfile(dir_source_task, ['sub-' subs{i}], ['echo' num2str(e)], 'func', '4D_Realigned.nii');
            nii_sub_echo = load_nii(dir_sub_echo);
            data_sub_echo = nii_sub_echo.img;
            data_sub_echo123(:,:,:,:,e) = data_sub_echo;
        end
        dir_save = fullfile(dir_tasks, ['sub-' subs{i}]);
        if ~exist(dir_save, 'dir')
            mkdir(dir_save);
        end
        for slice = 1:Nz
            for t = 1:Nt
                data_volume(:,:,:) = data_sub_echo123(:,:,slice,t,:);
                maxSig = max(max(max(data_volume)));
                Normed_data = data_volume/maxSig;
                data_save_name = fullfile(dir_save, ['sub-' subs{i} '_task-' tasks{taski} '_t' num2str(t,'%03d') '_s' num2str(slice,'%02d') '.mat']);
                save(data_save_name,'Normed_data','-v6');
            end
        end
    end
end
disp('Finished ARechoes2Normed2d!');
end