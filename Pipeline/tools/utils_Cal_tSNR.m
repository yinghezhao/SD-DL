function tSNR = utils_Cal_tSNR(dir_file, varargin)
% Input: 
%   dir_file: direction of input files.
%   start_time: timepoint to start. remove the first n("start_time") timepoints
    if size(varargin) == 1
        start_time = varargin{1};
        end_time = 'end';
    elseif size(varargin) == 2
        start_time = varargin{1};
        end_time = varargin{2};
    elseif size(varargin) == 0
        start_time = 1;
        end_time = 'end';
    end

    if ischar(dir_file)
        [filepath,name,ext] = fileparts(dir_file);
        if strcmp(ext,'.nii')
            nii = load_nii(dir_file);
            data_4D = double(nii.img);
        end
        if strcmp(ext,'.mat')
            data_4D = importdata(dir_file);
        end
    end
    if isnumeric(dir_file)
        data_4D = dir_file;
    end
    
    if ischar(end_time)
        data_4D = data_4D(:,:,:,start_time:end);
    else
        data_4D = data_4D(:,:,:,start_time:end_time);
    end
    [Ni, Nj, Nk, Nt] = size(data_4D);
    % 4D 转 2D 
    data_2D = reshape(data_4D, [Ni * Nj * Nk, Nt]); % [voxels, time]
    data_2D = data_2D'; % [time, voxels]
    % 计算tSNR
    % Remove linear and quadratic trends from data, per voxel
    data_2D_detrended = fmrwhy_util_detrend(data_2D, 2); % [time, voxels]
    % Calculate mean (ignore nan values)
    data_2D_mean = mean(data_2D_detrended(1:end,:)); % [1, voxels]
    % Calculate standard deviation
    data_2D_stddev = std(data_2D_detrended(1:end,:)); % [1, voxels]
    % Calculate tSNR
    data_2D_tsnr = data_2D_mean ./ data_2D_stddev; % [1, voxels]
    data_2D_tsnr(data_2D_tsnr < 0) = 0; % TODO: double check if this thresholding is fine to do, or give adequate reasoning
    data_3D_tsnr = reshape(data_2D_tsnr, Ni, Nj, Nk);

    data_3D_tsnr(data_3D_tsnr > 10000) = 0;
    tSNR = data_3D_tsnr;
end