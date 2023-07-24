function PSC_vals = utils_Cal_PSC(dir_GLM, varargin)
% Input:
%     dir_GLM:direction of GLM model.
%     varargin: 
%       if size(varargin) = 1, use physio information
%       if size(varargin) = 2, then use physio information and save PSC_vals

    % calculate PSC
    beta_condition_dir = fullfile(dir_GLM, 'beta_0001.nii');
    beta_constant_dir = fullfile(dir_GLM, 'beta_0008.nii');
    if size(varargin) == 1
        beta_constant_dir = fullfile(dir_GLM, 'beta_0022.nii');
    end
    spmmat_dir = fullfile(dir_GLM, 'SPM.mat');
    
    spm = load(spmmat_dir);
    ntime = 20*(1/spm.SPM.xBF.dt);
    reference_block =  conv(ones(1,ntime),spm.SPM.xBF.bf(:,1))';
    SF = max(reference_block);
    
    nii_beta_condition = load_nii(beta_condition_dir);
    beta_vals = double(nii_beta_condition.img);
    nii_beta_constant = load_nii(beta_constant_dir);
    const_vals = double(nii_beta_constant.img);
    
    PSC_vals = beta_vals * SF ./ const_vals * 100;
    
    % save PSC
    if size(varargin) == 2
        new_fn = fullfile(dir_GLM, 'PSC_0001.nii');
        no_scaling = 1;
        if ~exist(new_fn)
            fmrwhy_util_saveNifti(new_fn, PSC_vals, beta_condition_dir, no_scaling);
        end
    end
    
end