function Dice = Cal_Dice(Parameter,modality,threshold)
subs = Parameter.subs;
Dice = struct;

tasks = {'rest_run-1','rest_run-2'};
dir_rest1 = fullfile(Parameter.dir_DPABI,tasks{1});
dir_rest2 = fullfile(Parameter.dir_DPABI,tasks{2});

for modali = 1:length(modality)
    dir_rest1_model = fullfile(dir_rest1,modality{modali},'Results','FC_FunImgARCW');
    dir_rest2_model = fullfile(dir_rest2,modality{modali},'Results','FC_FunImgARCW');
    listing_ROI = dir(dir_rest1_model);
    for ROIi = 1:length(listing_ROI)
        if(isequal(listing_ROI(ROIi).name,'.') ||...
                isequal(listing_ROI(ROIi).name,'..') ||...
                ~listing_ROI(ROIi).isdir)
            continue;
        end
        ROIname = listing_ROI(ROIi).name;
        dir_ROI_rest1 = fullfile(dir_rest1_model, ROIname);
        dir_ROI_rest2 = fullfile(dir_rest2_model, ROIname);
        for subi = 1:length(subs)
            dir_sub_rest1 = fullfile(dir_ROI_rest1,['zFCMap_sub-' subs{subi} '.nii']);
            dir_sub_rest2 = fullfile(dir_ROI_rest2,['zFCMap_sub-' subs{subi} '.nii']);
            Dice_value = utils_Cal_Dice(dir_sub_rest1,dir_sub_rest2,threshold);
            eval([ 'Dice.' ROIname '(subi).' modality{modali} '= Dice_value;']);
        end
    end
end
save(fullfile(Parameter.dir_result, 'Dice.mat'), 'Dice');
Plot_Save_Dice(Parameter, Dice, modality);
Cal_PairedT(Parameter, Dice, 'FC');

end