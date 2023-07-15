function ComparisonMetrics(Parameter, tasks, modality )
subs = Parameter.subs;
use_phy = Parameter.use_phy;
contrast_vector = zeros(1, Parameter.TotalTimepoints);
for n = 1:length(Parameter.TaskOnsets)
    for m = Parameter.TaskOnsets(n):(Parameter.TaskOnsets(n)+Parameter.TaskDurations(n)-1)
        contrast_vector(m) = 1;
    end
end
contrast_vector = logical(contrast_vector);

for taski = 1:length(tasks)
    dir_save_result = fullfile(Parameter.dir_result,tasks{taski});
    if ~exist(dir_save_result,'dir') && Parameter.AutoSave == 1
        mkdir(dir_save_result);
    end
    excel_name = fullfile(dir_save_result,'NumOfROIVoxels.xlsx');
    dir_task = fullfile(Parameter.dir_root, tasks{taski});
    act_V = cell(length(subs),1);
    actvVoxels = struct;
    t_value = struct;
    PSC = struct;
    tPSC = struct;
    movtPSC = struct;
    fc = struct; %Functional contrast
    
    parfor i = 1:length(subs)
        dir_sub = fullfile(dir_task, ['sub-' subs{i}]);
        act_V{i,1} = ['sub-' subs{i} ' ' num2str(num_voxel_ROI)];
        dir_ROI_FWE_OR = fullfile(dir_sub, 'ROI_FWE_OR.nii');
        data_ROI_FWE_OR = load_nii(dir_ROI_FWE_OR).img;
        num_voxel_ROI = sum(sum(sum(data_ROI_FWE_OR)));
        listing = dir(dir_sub);
        for j = 1:length(listing)
            if( isequal( listing( j ).name, '.' )||...
                    isequal( listing( j ).name, '..')||...
                    ~listing( j ).isdir||...
                    ~ismember( listing( j ).name, modality))
                continue;
            end
            subdir = fullfile( dir_sub, listing( j ).name );
            % Calculate percent_actv_ROI
            dir_ROI_sub = fullfile(subdir, 'model', 'spmT_0001_ROI_p0001extend3.nii');
            data_ROI_sub = load_nii(dir_ROI_sub).img;
            actv_ROI_sub = sum(sum(sum(data_ROI_sub.*data_ROI_FWE_OR)));
            percent_actv_ROI = actv_ROI_sub/num_voxel_ROI;
            % Calculate t-value
            dir_t = fullfile(subdir, 'model', 'spmT_0001.nii');
            data_t = load_nii(dir_t).img;
            t_map = double(data_t).*double(data_ROI_FWE_OR);
            mean_t = mean(mean(mean(t_map(t_map~=0))));
            % Calculate PSC
            dir_GLM = fullfile(subdir, 'model');
            PSC_vals = utils_Cal_PSC(dir_GLM,(use_phy == 1));
            mean_PSC = utils_Cal_meanPSC(PSC_vals,dir_ROI_FWE_OR);
            % Calculate tPSC and fc
            dir_smoothed_data = fullfile(subdir, 'func', '4D_smoothed.nii');
            [tPSC_sub, fc_sub, mean_tCNR] = utils_Cal_tPSC(dir_smoothed_data,contrast_vector,dir_ROI_FWE_OR);
            [tPSC_sub_realtime, ~, ~] = utils_Cal_tPSC(dir_smoothed_data,contrast_vector,dir_ROI_FWE_OR,10);
            mov_tPSC_sub = movmean(tPSC_sub,3);
            mov_tPSC_sub_realtime = movmean(tPSC_sub_realtime,3);
            
            % write results into Structs
            actvVoxels(i).(listing( j ).name) = percent_actv_ROI;
            t_value(i).(listing( j ).name) = mean_t;
            PSC(i).(listing( j ).name) = mean_PSC;
            tPSC(i).(listing( j ).name) = tPSC_sub;
            movtPSC(i).(listing( j ).name) = mov_tPSC_sub;
            movtPSC_rt(i).(listing( j ).name) = mov_tPSC_sub_realtime;
            fc(i).(listing( j ).name) = fc_sub;
            tCNR(i).(listing( j ).name) = mean_tCNR;
        end
    end
    % save variables
    if Parameter.AutoSave == 1
        if exist(fullfile(dir_save_result, 'variables.mat'),'file')
            warning('The original file will be overwritten');
        end
        save(fullfile(dir_save_result, 'variables.mat'),'actvVoxels','t_value','PSC','movtPSC','fc','tCNR');
    end
    
    act_V2 = split(act_V);
    if exist(excel_name,'file')
        warning(['已存在文件：' excel_name ',不覆盖该文件']);
    end
    if ~exist(excel_name,'file') && Parameter.AutoSave == 1
        writecell(act_V2, excel_name);
    end
    
    modal_name = fieldnames(tPSC);
    % plot results
    Plot_Save_Results(actvVoxels,modal_name,dir_save_result,'ActiveVoxelsPercent','boxplot');
    Plot_Save_Results(t_value,modal_name,dir_save_result,'t_value','boxplot');
    Plot_Save_Results(PSC,modal_name,dir_save_result,'PSC','boxplot');
    Plot_Save_Results(fc,modal_name,dir_save_result,'Funtional Contrast','boxplot');
    Plot_Save_Results(tCNR,modal_name,dir_save_result,'tCNR','boxplot');
    
    % tPSC
    subi = 1;
    tPSC_result_name = ['tPSC_' tasks{taski} '_sub-' subs{subi} '_movmean 3points'];
    Plot_Save_tPSC(movtPSC(subi), length(modality),dir_save_result,tPSC_result_name);
    tPSCrt_result_name = ['tPSC-realtime_' tasks{taski} '_sub-' subs{subi} '_movmean 3points'];
    Plot_Save_tPSC(movtPSC_rt(subi), length(modality),dir_save_result,tPSCrt_result_name);
end
disp('Finished ComparisonMetrics!');
end