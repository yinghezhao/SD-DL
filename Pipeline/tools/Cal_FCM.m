function FCMatrixs = Cal_FCM(Parameter, modality, tasks)
subs = Parameter.subs;
dir_templatefile = fullfile(Parameter.dir_Template,'Reslice_AAL3v1_1mm.nii');
Num_node = 170;
FC_source_folder = 'FunImgARCW';
filename = 'wCovRegressed_4DVolume.nii';

FCMatrixs = zeros(Num_node,Num_node,length(subs),length(modality),length(tasks));

for taski = 1:length(tasks)
    dir_task = fullfile(Parameter.dir_DPABI , tasks{taski});
    for modali = 1:length(modality)
        dir_modal = fullfile(dir_task, modality{modali});
        dir_source_FC = fullfile(dir_modal, FC_source_folder);
        for subi = 1:length(subs)
            dir_sub = fullfile(dir_source_FC, ['sub-' subs{subi}]);
            dir_data = fullfile(dir_sub, filename);
            FCMatrixs(:,:,subi,modali,taski) = CalculateROICorrelation(dir_data, dir_templatefile);
        end
    end
end

savename = fullfile(Parameter.dir_result, 'FCMatrixs.mat');
save(savename, 'FCMatrixs');
disp('Finished Cal_FCM');
end