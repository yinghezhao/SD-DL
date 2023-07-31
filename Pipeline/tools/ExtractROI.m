function ExtractROI(Parameter,list_ROInum)

dir_aal3 = fullfile(Parameter.dir_Template,'Reslice_AAL3v1_1mm.nii');
dir_aal3_num = fullfile(Parameter.dir_Template,'AAL3v1.nii.txt');
dir_des = fullfile(Parameter.dir_DPABI,'ROI');
if ~exist(dir_des,'dir')
    mkdir(dir_des);
end

default_listnum = {'151','152','41','42','33','34','39','40','1','2'};

if isempty(list_ROInum)
    list_ROInum = default_listnum;
end

nii_aal3 = load_nii(dir_aal3);
aal3 = nii_aal3.img;
num_name = importdata(dir_aal3_num);

for numi = 1:length(list_ROInum)
    ROI = aal3;
    ROI(find(ROI ~= str2num(list_ROInum{numi}))) = 0;
    nii_ROI = {};
    nii_ROI.img = ROI;
    nii_ROI.hdr = nii_aal3.hdr;
    save_name = fullfile(dir_des, ['Resliced_AAL3_' num_name.textdata{str2num(list_ROInum{numi}),2} '_' list_ROInum{numi} '.nii']);
    disp(save_name);
    save_nii(nii_ROI,save_name);
end

end