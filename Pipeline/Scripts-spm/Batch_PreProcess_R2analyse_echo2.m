function matlabbatch = Batch_PreProcess_R2analyse_echo2(dir_Reference, dir_T1raw, dir_3D_Realigned,dir_model, multi_reg,dir_promap)
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {[dir_Reference ',1']};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {[dir_T1raw ',1']};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{2}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{2}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{2}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{2}.spm.spatial.preproc.tissue(1).tpm = {[dir_promap ',1']}; % {'/home/zyh/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{2}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{2}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{2}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(2).tpm = {'D:\MySoftwares\MATLAB\toolbox\spm12\tpm\TPM.nii,2'};
matlabbatch{2}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{2}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{2}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(3).tpm = {'D:\MySoftwares\MATLAB\toolbox\spm12\tpm\TPM.nii,3'};
matlabbatch{2}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{2}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{2}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(4).tpm = {'D:\MySoftwares\MATLAB\toolbox\spm12\tpm\TPM.nii,4'};
matlabbatch{2}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{2}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{2}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(5).tpm = {'D:\MySoftwares\MATLAB\toolbox\spm12\tpm\TPM.nii,5'};
matlabbatch{2}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{2}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{2}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(6).tpm = {'D:\MySoftwares\MATLAB\toolbox\spm12\tpm\TPM.nii,6'};
matlabbatch{2}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{2}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{2}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{2}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{2}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{2}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{2}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{2}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{2}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{2}.spm.spatial.preproc.warp.write = [0 1];
matlabbatch{2}.spm.spatial.preproc.warp.vox = NaN;
matlabbatch{2}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                              NaN NaN NaN];
matlabbatch{3}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{3}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
matlabbatch{3}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{3}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
matlabbatch{3}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{3}.spm.spatial.normalise.write.woptions.prefix = 'w';
matlabbatch{4}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{4}.spm.spatial.normalise.write.subj.resample = dir_3D_Realigned;  
matlabbatch{4}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{4}.spm.spatial.normalise.write.woptions.vox = [3.5 3.5 3.5];
matlabbatch{4}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{4}.spm.spatial.normalise.write.woptions.prefix = 'w';
matlabbatch{5}.spm.util.cat.vols(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{5}.spm.util.cat.name = '4D_Normalised.nii';
matlabbatch{5}.spm.util.cat.dtype = 0;
matlabbatch{5}.spm.util.cat.RT = NaN;
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [7 7 7];
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 's';
matlabbatch{7}.spm.util.cat.vols(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.util.cat.name = '4D_Smoothed.nii';
matlabbatch{7}.spm.util.cat.dtype = 0;
matlabbatch{7}.spm.util.cat.RT = NaN;
matlabbatch{8}.spm.stats.fmri_spec.dir = {dir_model};
matlabbatch{8}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{8}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{8}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.name = 'fingerTapping';
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.onset = [21
                                                      61
                                                      101
                                                      141
                                                      181
                                                      221
                                                      261
                                                      301
                                                      341
                                                      381];
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.duration = 20;
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.tmod = 0;
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{8}.spm.stats.fmri_spec.sess.cond.orth = 1;
matlabbatch{8}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{8}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{8}.spm.stats.fmri_spec.sess.multi_reg = multi_reg;
matlabbatch{8}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{8}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{8}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{8}.spm.stats.fmri_spec.volt = 1;
matlabbatch{8}.spm.stats.fmri_spec.global = 'None';
matlabbatch{8}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{8}.spm.stats.fmri_spec.mask = {''};
matlabbatch{8}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{9}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{9}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{9}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{10}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{10}.spm.stats.con.consess{1}.tcon.name = 'fingerTapping';
matlabbatch{10}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{10}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{10}.spm.stats.con.delete = 0;
matlabbatch{11}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{11}.spm.stats.results.conspec.titlestr = '';
matlabbatch{11}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{11}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{11}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{11}.spm.stats.results.conspec.extent = 3;
matlabbatch{11}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{11}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{11}.spm.stats.results.units = 1;
matlabbatch{11}.spm.stats.results.export{1}.ps = true;
matlabbatch{11}.spm.stats.results.export{2}.binary.basename = 'ROI_p0001extend3';    
end