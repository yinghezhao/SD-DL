function Cal_FC(Parameter, tasks, modality)
subs = Parameter.subs;

dir_ROI = fullfile(Parameter.dir_DPABI, 'ROI');
FC_source_folder = 'FunImgARCW';
DimX = 53;
DimY = 63;
DimZ = 53;

for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_DPABI, tasks{taski});
    OutputList = cell(1,1);
    Num_Output = 0;
    for modali = 1:length(modality)
        dir_modal = fullfile(dir_task, modality{modali});
        dir_source_FC = fullfile(dir_modal, FC_source_folder);
        dir_Results_FC = fullfile(dir_modal, 'Results', ['FC_' FC_source_folder]);
        if ~exist(fullfile(dir_modal, 'Results'),'dir')
            mkdir(fullfile(dir_modal, 'Results'));
        end
        if ~exist(dir_Results_FC)
            mkdir(dir_Results_FC);
        end
        listROI = dir(dir_ROI);
        for ROIi = 1:length(listROI)
            if( isequal( listROI( ROIi ).name, '.' )||...
                    isequal( listROI( ROIi ).name, '..'))
                continue;
            end
            dir_ROIDef = {fullfile(dir_ROI, listROI( ROIi ).name)};
            folder_seed_name = split(listROI( ROIi ).name,'.');
            folder_seed_name = folder_seed_name{1};
            dir_Results_Seed = fullfile(dir_Results_FC, folder_seed_name);
            if ~exist(dir_Results_Seed)
                mkdir(dir_Results_Seed);
            end    
            for subi = 1:length(subs)
                dir_sub = fullfile(dir_source_FC, ['sub-' subs{subi}]);
                listing = dir(dir_sub);
                OutputName = fullfile(dir_Results_Seed, ['FCMap_sub-' subs{subi} '.nii']);
                Num_Output = Num_Output + 1;
                OutputList{Num_Output} = OutputName;
                if exist(OutputName)
                    disp([OutputName ' exists! file will not be overwritten.']);
                    continue;
                end
                for j = 1:length(listing)
                    if( isequal( listing( j ).name, '.' )||...
                            isequal( listing( j ).name, '..'))
                        continue;
                    end
                    dir_FC_AllVolume = fullfile(dir_sub, listing( j ).name);
                end
                dir_MaskData = ones(DimX,DimY,DimZ);
                y_SCA(dir_FC_AllVolume, dir_ROIDef, OutputName, dir_MaskData);
            end
        end
    end
    disp(['Finished task-' tasks{taski}]);
end
disp('Finished Cal_FC');
end