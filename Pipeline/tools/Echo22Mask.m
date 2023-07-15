function Echo22Mask(dir_root,tasks,Parameter)
subs = Parameter.subs;
for taski = 1:length(tasks)
    for subi = 1:length(subs)
        dir_data = fullfile(dir_root, tasks{taski}, ['sub-' subs{subi}], 'echo2', 'func', '4D_Realigned.nii');
        dir_save = fullfile(dir_root, tasks{taski}, ['sub-' subs{subi}]);
        data = rot90(double(load_nii(dir_data).img(:,:,:,Parameter.MaskTimepoint)));
        mask = data./max(data(:));
        mask = imbinarize(mask,Parameter.level);
        save(fullfile(dir_save, 'mask.mat'),'mask');
    end
end
disp(['Finished Echo22Mask!']);
end