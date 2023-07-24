function ARechoes2Normed2d_average(Parameter, tasks)
subs = Parameter.subs;
Nx = Parameter.VoxelNumber(1);
Ny = Parameter.VoxelNumber(2);
Nz = Parameter.VoxelNumber(3);
Ne = length(Parameter.TE);
time_name = 1;
if ~exist(fullfile(Parameter.dir_Normed,'average'), 'dir')
    mkdir(fullfile(Parameter.dir_Normed,'average'));
end
    
for taski = 1:length(tasks)
    dir_source_task = fullfile(Parameter.dir_root, tasks{taski});
    dir_tasks = fullfile(Parameter.dir_Normed,'average', tasks{taski});
    if ~exist(dir_tasks, 'dir')
        mkdir(dir_tasks);
    end
    for i = 1:length(subs)
        data_sub_echo123_mean = zeros(Nx, Ny, Nz, Ne);
        for e = 1:Ne
            dir_sub_echo = fullfile(dir_source_task, ['sub-' subs{i}], ['echo' num2str(e)], 'func', '4D_Realigned.nii');
            niifile = load_nii(dir_sub_echo);
            data_sub_echo = niifile.img;
            data_sub_echo123_mean(:,:,:,e) = mean(data_sub_echo,4);
        end
        dir_save = fullfile(dir_tasks, ['sub-' subs{i}]);
        if ~exist(dir_save, 'dir')
            mkdir(dir_save);
        end
        for slice = 1:Nz
            data_volume = data_sub_echo123_mean(:,:,slice,:);
            maxSig = max(max(max(data_volume)));
            Normed_data = squeeze(data_volume/maxSig);
            data_save_name = fullfile(dir_save, ['sub-' subs{i} '_task-' tasks{taski} '_t' num2str(time_name,'%03d') '_s' num2str(slice,'%02d') '.mat']);
            save(data_save_name,'Normed_data','-v6');
        end
    end
end
disp('Finished ARechoes2Normed2d_average!');
end