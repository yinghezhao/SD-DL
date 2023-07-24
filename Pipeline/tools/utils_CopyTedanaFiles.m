function utils_CopyTedanaFiles(dir_echo2_Realigned,dir_OC,dir_MEICA)

outputfolder = fullfile(dir_MEICA, 'tedana_output');
gzipfilenames1 = fullfile(outputfolder, 'desc-optcom_bold.nii.gz');
gzipfilenames2 = fullfile(outputfolder, 'desc-optcomDenoised_bold.nii.gz');
if ~exist(gzipfilenames1)
    disp(['file does not exists: ' gzipfilenames1]);
    return
end
if ~exist(gzipfilenames2)
    disp(['file does not exists: ' gzipfilenames2]);
    return
end

filenames1 = gunzip(gzipfilenames1,outputfolder);
filenames2 = gunzip(gzipfilenames2,outputfolder);
dir_copy_OC = fullfile(dir_OC, 'func');
dir_copy_MEICA = fullfile(dir_MEICA, 'func');

oldname1 = 'desc-optcom_bold.nii';
oldname2 = 'desc-optcomDenoised_bold.nii';
newname = '4D_Realigned.nii';
if exist(fullfile(dir_copy_OC, newname))
    disp(['file exists: ' fullfile(dir_copy_OC, newname)]);
    return
end
if exist(fullfile(dir_copy_MEICA, newname))
    disp(['file exists: ' fullfile(dir_copy_MEICA, newname)]);
    return
end

copyfile(filenames1{1},dir_copy_OC);
copyfile(filenames2{1},dir_copy_MEICA);

nii_echo2 = load_nii(dir_echo2_Realigned);

nii_OC = load_nii(fullfile(dir_copy_OC, oldname1));
data_OC = nii_OC.img;
new_nii = {};
new_nii.img = data_OC;
new_nii.hdr = nii_echo2.hdr;
save_name = fullfile(dir_copy_OC, newname);

save_nii(new_nii,save_name);

nii_MEICA = load_nii(fullfile(dir_copy_MEICA, oldname2));
data_MEICA = nii_MEICA.img;
new_nii = {};
new_nii.img = data_MEICA;
new_nii.hdr = nii_echo2.hdr;
save_name = fullfile(dir_copy_MEICA, newname);
save_nii(new_nii,save_name);

delete(filenames1{1});
delete(filenames2{1});
end