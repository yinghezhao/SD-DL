function dir_delete = utils_DeleteTempFiles(dir_folder,type,del)
% del = 1 : delete tempfiles
% del = 0 : do not delete tempfiles
listing = dir(dir_folder);
dir_delete = {};
if isequal(type,'T1') || isequal(type,'anat')
    % Delete split files starting with 'c'
    save_fix = [];
    del_fix = {'c'};
elseif isequal(type,'func')
    % Delete files ending with numbers+'. nii' and keep files starting with 'mean'
    save_fix = 'mean';
    del_fix = {'desc', '0.nii', '1.nii', '2.nii', '3.nii', '4.nii', '5.nii', '6.nii', '7.nii', '8.nii', '9.nii'};
elseif isequal(type,'MEICA')
    % Remove cat_ echo123 file if exists
    save_fix = [];
    del_fix = {'cat'};
else
    print(['Error! The type is irregular!'])
end
for i = 1:length(listing)
    if (listing( i ).isdir  ||...
            ~isempty(strfind(listing( i ).name, save_fix)))
        continue;
    end
    for fix_i = 1:length(del_fix)
        temp_fix = del_fix{fix_i};
        dir_file = fullfile(listing( i ).folder, listing( i ).name);
        if ~isempty(strfind(listing( i ).name, temp_fix)) && ~ismember(dir_file, dir_delete)
            dir_delete = [dir_delete; dir_file];
        end
    end
end

if del == 1
    for j = 1:length(dir_delete)
        delete(dir_delete{j});
    end
end

end