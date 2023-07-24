function Cal_Realigned(Parameter, tasks, modality)
subs = Parameter.subs;
level_mask = Parameter.level;
TE_t2s = Parameter.TE/1000;
minimum = Parameter.minimum;
maxT2 = Parameter.maxT2;
for taski = 1:length(tasks)
    dir_data = fullfile(Parameter.dir_root, tasks{taski});
    for i = 1:length(subs)
        dir_sub = fullfile(dir_data, ['sub-' subs{i}]);
        for e = 1:3
            dir_echo_Realigned = fullfile(dir_sub, ['echo' num2str(e)], 'func', '4D_Realigned.nii');
            func_Realigned(:,:,:,:,e) = load_nii(dir_echo_Realigned).img;
            if e == 2
                save_hdr = load_nii(dir_echo_Realigned).hdr;
            end
        end
        [Ni, Nj, Nk, Nt, ~] = size(func_Realigned);
        for j = 1:length(modality)
            dir_mod = fullfile(dir_sub, modality{j});
            if ~exist(dir_mod)
                mkdir(dir_mod)
            end
            if ~exist(fullfile(dir_mod, 'anat'))
                mkdir(fullfile(dir_mod, 'anat'))
                copyfile(fullfile(dir_data, ['sub-' subs{i}], 'echo2', 'anat', ['sub-' subs{i} '_T1w.nii']) ,fullfile(dir_mod, 'anat',['\sub-' subs{i} '_T1w.nii']));
            end
            if ~exist(fullfile(dir_mod, 'func'))
                mkdir(fullfile(dir_mod, 'func'))
            end
            if ~exist(fullfile(dir_mod, 'model'))
                mkdir(fullfile(dir_mod, 'model'))
            end
            if isequal(modality{j},'TEcom')
                % Calculate TE-combined
                save_data = me_fMRI_combineEchoes(func_Realigned, Parameter.TE, 3);
                disp(['Finished TE combined!']);
            elseif isequal(modality{j},'t2star_3')
                % Calculate t2* 3echoes
                indata_t2s3 = cat(5,func_Realigned(:,:,:,:,1),func_Realigned(:,:,:,:,2),func_Realigned(:,:,:,:,3));
                data_t2s3 = zeros(Ni, Nj, Nk, Nt);
                parfor k = 1:Nk
                    for t = 1:Nt
                        % t2*
                        MASK = func_Realigned(:,:,k,t,1);
                        MASK = MASK./max(MASK(:));
                        MASK = im2bw(MASK,level_mask);
                        [Map ~] = T2Map(squeeze(indata_t2s3(:,:,k,t,:)), TE_t2s, minimum, maxT2)
                        data_t2s3(:,:,k,t) = Map(:,:,2).*MASK;
                    end
                    disp(['Finished slice ',num2str(k)]);
                end
                save_data=uint16(data_t2s3 * 8000 + 10);
                disp(['Finished all slices!']);
            elseif isequal(modality{j},'t2star_2')
                % Calculate t2* 2echoes
                data_t2s2 = (TE_t2s(3)-TE_t2s(2))./(log(func_Realigned(:,:,:,:,2)./func_Realigned(:,:,:,:,3)));
                data_t2s2(isnan(data_t2s2)) = 0;
                data_t2s2(data_t2s2==inf) = 0;
                disp(['Finished t2*!']);
                save_data=uint16(data_t2s2 * 8000 + 10);
            else
                error([modality{j} 'does not exists!']);
            end
            % save files
            nii = {};
            nii.img = save_data;
            nii.hdr = save_hdr;
            save_name_mod = fullfile(dir_mod, 'func', '4D_Realigned.nii');
            save_nii(nii,save_name_mod);
            disp(['Finished save files!']);
        end
    end
end
disp(['Finished Cal_Realigned!']);
end