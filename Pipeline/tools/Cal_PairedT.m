function [PairedT_h,PairedT_p] = Cal_PairedT(Parameter, data, datatype)

if isequal(datatype, 'FC')
    ROInames = fieldnames(data);
    for namei = 1:length(ROInames)
        Dicemodal = data.(ROInames{namei});
        array_Dice(:,:,namei) = table2array(struct2table(Dicemodal));
        [h,p] = ttest(array_Dice(:,1,namei),array_Dice(:,2,namei));
        PairedT_h(namei) = h;
        PairedT_p(namei) = p;
    end
    save(fullfile(Parameter.dir_result, 'PairedT_Dice_FC.mat'), 'PairedT_h', 'PairedT_p');
elseif isequal(datatype, 'FCM')
    [len_thr,len_mod,len_subs] = size(data);
    for thri = 1:len_thr
        [h,p] = ttest(data(thri, 1, :), data(thri, 2, :));
        PairedT_h(thri) = h;
        PairedT_p(thri) = p;
    end
    save(fullfile(Parameter.dir_result, 'PairedT_Dice_FCM.mat'), 'PairedT_h', 'PairedT_p');
else
    Warning('Please Check datatype! (Cal_PairedT)');
end

end