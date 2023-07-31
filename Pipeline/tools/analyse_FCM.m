function Dice_coff = analyse_FCM(Parameter, tasks, modality)
subs = Parameter.subs;
threshold_list = [0.3,0.4,0.5,0.6];

if exist(fullfile(Parameter.dir_result, 'FCMatrixs.mat'),'file')
    load(fullfile(Parameter.dir_result, 'FCMatrixs.mat'));
else
    FCMatrixs = Cal_FCM(Parameter, modality, tasks);
end

Dice_coff = zeros(length(threshold_list),length(modality), length(subs));
for thri = 1:length(threshold_list)
    threshold = threshold_list(thri);
    FC_thr = im2bw(FCMatrixs, threshold);  % 170 170 length(subs) length(modality) length(tasks)
    for modali = 1:length(modality)
        for subi = 1:length(subs)
            Dice_coff(thri,modali,subi) = dice(FC_thr(:,:,subi,modali,1), FC_thr(:,:,subi,modali,2));
        end
    end
    
end

Cal_PairedT(Parameter, Dice_coff, 'FCM');

end