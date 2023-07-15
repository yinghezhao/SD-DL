function Cal_ROI(Parameter, tasks, modality)

for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root,tasks{taski});
    for i = 1:length(Parameter.subs)
        dir_sub = fullfile(dir_data, ['sub-' Parameter.subs{i}]);
        listing = dir(dir_sub);
        ROI_sub = zeros(Parameter.VoxelNumber(1),Parameter.VoxelNumber(2),Parameter.VoxelNumber(3));
        for j = 1:length(listing)
            if( isequal( listing( j ).name, '.' )||...
                    isequal( listing( j ).name, '..')||...
                    ~listing( j ).isdir||...
                    ~ismember(listing( j ).name, modality))
                continue;
            end
            subdir = fullfile( dir_sub, listing( j ).name );
            dir_ROI = fullfile(subdir, 'model2', 'spmT_0001_ROI_p0001extend3.nii');
            nii_ROI = load_nii(dir_ROI);
            data_ROI = nii_ROI.img;
            ROI_sub = or(data_ROI , ROI_sub);
            
            nii_ROI_sub = {};
            nii_ROI_sub.img = ROI_sub;
            nii_ROI_sub.hdr = nii_ROI.hdr;
            save_name = fullfile(dir_sub, 'ROI_FWE_OR.nii');
            save_nii(nii_ROI_sub,save_name);
        end
    end
end
disp(['Finished Cal_ROI!']);
end