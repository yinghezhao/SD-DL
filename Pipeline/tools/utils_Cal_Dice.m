function Dice = utils_Cal_Dice(dir_rest1,dir_rest2,threshold)
if isnumeric(dir_rest1)
    data_rest1 = dir_rest1;
elseif ischar(dir_rest1)
    [filepath,name,ext] = fileparts(dir_rest1);
    if strcmp(ext,'.nii')
        nii = load_nii(dir_rest1);
        data_rest1 = nii.img;
    end
else
    error("neither dir_rest1 is numeric matrix nor Folder Path");
end


if isnumeric(dir_rest2)
    data_rest2 = dir_rest2;
elseif ischar(dir_rest2)
    [filepath,name,ext] = fileparts(dir_rest2);
    if strcmp(ext,'.nii')
        nii = load_nii(dir_rest2);
        data_rest2 = nii.img;
    end
else
    error("neither dir_rest1 is numeric matrix nor Folder Path");
end

data_rest1 = imbinarize(data_rest1,threshold);
data_rest2 = imbinarize(data_rest2,threshold);

data_Intersec = sum(sum(sum( data_rest1 & data_rest2 )));
data_Union = sum(sum(sum( data_rest1))) + sum(sum(sum( data_rest2 )));
Dice = 2 * data_Intersec / data_Union;

end