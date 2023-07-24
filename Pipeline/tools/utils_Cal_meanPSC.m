function mean_PSC = utils_Cal_meanPSC(PSC_vals,dir_ROI)
% Input:
%     PSC_vals: value of PSC % such as 45 * 55 * 45
%     dir_ROI:direction of ROI( .nii file)
    nii_ROI = load_nii(dir_ROI);
    data_ROI = double(nii_ROI.img);
    calculate_PSC = data_ROI.*PSC_vals;
    [Ni,Nj,Nk] = size(PSC_vals);
    re_PSC = sort(reshape(calculate_PSC, 1, Ni * Nj * Nk)); % 从小到大排序
    PSCvalue = re_PSC(re_PSC>0);
    mean_PSC = mean(PSCvalue); % mean_PSC即为所求
end