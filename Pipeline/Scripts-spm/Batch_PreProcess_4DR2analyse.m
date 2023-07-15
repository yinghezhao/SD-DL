function Batch_PreProcess_4DR2analyse(dir_func, dir_4D_Realigned,dir_model, multi_reg)

matlabbatch{1}.spm.util.split.vol = {[dir_4D_Realigned ',1']};
matlabbatch{1}.spm.util.split.outdir = {dir_func};
matlabbatch{2}.spm.spatial.smooth.data(1) = cfg_dep('4D to 3D File Conversion: Series of 3D Volumes', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','splitfiles'));
matlabbatch{2}.spm.spatial.smooth.fwhm = [7 7 7];
matlabbatch{2}.spm.spatial.smooth.dtype = 0;
matlabbatch{2}.spm.spatial.smooth.im = 0;
matlabbatch{2}.spm.spatial.smooth.prefix = 's';
matlabbatch{3}.spm.util.cat.vols(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.util.cat.name = '4D_Smoothed.nii';
matlabbatch{3}.spm.util.cat.dtype = 0;
matlabbatch{3}.spm.util.cat.RT = NaN;
matlabbatch{4}.spm.stats.fmri_spec.dir = {dir_model};
matlabbatch{4}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{4}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{4}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.name = 'fingerTapping';
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.onset = [21
                                                      61
                                                      101
                                                      141
                                                      181
                                                      221
                                                      261
                                                      301
                                                      341
                                                      381];
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.duration = 20;
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.tmod = 0;
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{4}.spm.stats.fmri_spec.sess.cond.orth = 1;
matlabbatch{4}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{4}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{4}.spm.stats.fmri_spec.sess.multi_reg = multi_reg;
matlabbatch{4}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{4}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{4}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{4}.spm.stats.fmri_spec.volt = 1;
matlabbatch{4}.spm.stats.fmri_spec.global = 'None';
matlabbatch{4}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{4}.spm.stats.fmri_spec.mask = {''};
matlabbatch{4}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{5}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{6}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{6}.spm.stats.con.consess{1}.tcon.name = 'fingerTapping';
matlabbatch{6}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{6}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{6}.spm.stats.con.delete = 0;
matlabbatch{7}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{7}.spm.stats.results.conspec.titlestr = '';
matlabbatch{7}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{7}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{7}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{7}.spm.stats.results.conspec.extent = 3;
matlabbatch{7}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{7}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{7}.spm.stats.results.units = 1;
matlabbatch{7}.spm.stats.results.export{1}.ps = true;
matlabbatch{7}.spm.stats.results.export{2}.binary.basename = 'ROI_p0001extend3';
end