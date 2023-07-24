function [tPSC_ROI,FC_ROI,tCNR_ROI] = utils_Cal_tPSC(smoothed_data_dir,contrast_vector,dir_ROI,varargin)
% smoothed_data_dir: directory
% Resliced_ROI: ROI data or directory of ROI

if isnumeric(dir_ROI)
    Resliced_ROI = dir_ROI;
elseif ischar(dir_ROI)
    [filepath,name,ext] = fileparts(dir_ROI);
    if strcmp(ext,'.nii')
        nii = load_nii(dir_ROI);
        Resliced_ROI = nii.img;
    end
end
if ischar(smoothed_data_dir)
    nii = load_nii(smoothed_data_dir);
    data_4D = double(nii.img);
elseif isnumeric(smoothed_data_dir)
    data_4D = smoothed_data_dir;
end
[Ni, Nj, Nk, Nt] = size(data_4D); % [Ni x Nj x Nk x Nt]
data_2D = reshape(data_4D, Ni * Nj * Nk, Nt); % [voxels, time]
data_2D = data_2D'; % [time, voxels]

% Remove linear and quadratic trend per voxel
data_2D_detrended = fmrwhy_util_detrend(data_2D, 2); % [time, voxels]

% Calculate mean
if nargin == 3
    data_2D_mean = nanmean(data_2D_detrended); % [1, voxels]
elseif nargin > 3
    data_2D_mean = nanmean(data_2D_detrended(1:varargin{1},:)); % [1, voxels]
end

% Calculate percentage signal change: [I(t) - mean(I)]/mean(I)*100
data_2D_psc = 100 * (data_2D_detrended ./ data_2D_mean) - 100;
data_2D_psc(isnan(data_2D_psc)) = 0; % [time, voxels]

% mov3mean
data_2D_psc = movmean(data_2D_psc,3,1);

ON_volumes = contrast_vector;
OFF_volumes = ~contrast_vector;
fc_voxels = mean(abs(data_2D_psc(ON_volumes,:))) - mean(data_2D_psc(OFF_volumes,:)); % [1, voxels]
std_off = std(data_2D_psc(OFF_volumes,:)); % [1, voxels]
tCNR = reshape(fc_voxels./std_off,Ni, Nj, Nk); % [Ni, Nj, Nk]
tCNR(isnan(tCNR)) = 0;

F_2D_psc = data_2D_psc';
ROI_signals = F_2D_psc(logical(reshape(Resliced_ROI, Ni * Nj * Nk, 1)'), :); % [ROIvoxels, time]
tPSC_ROI = mean(ROI_signals, 1); % [1, time]
FC_ROI = mean(fc_voxels(logical(reshape(Resliced_ROI, Ni * Nj * Nk, 1))));
tCNR_ROI = tCNR .* logical(Resliced_ROI);
tCNR_ROI = mean(tCNR_ROI(tCNR_ROI~=0)); % [1,1]

end