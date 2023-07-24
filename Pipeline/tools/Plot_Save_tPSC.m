function Plot_Save_tPSC(tPSCdata_sub, num_mod,dir_save_result,name)
savename = fullfile(dir_save_result,[name '.png']);
savefiles = 1;
Colors = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30','#4DBEEE'};
Markers = {'none', 'o', '+', 's'};

if exist(savename,'file')
    savefiles = 0;
    warning([name ' exists, original file will not be overwritten ']);
end

scrsz = get(0,'ScreenSize');
fig_results = figure('Position',[0 30 scrsz(3) scrsz(4)-95]);
hold on;
p = structfun(@plot,tPSCdata_sub);
% for mod_i = 1:num_mod
%     mod_m = ceil(mod_i / length(Colors));
%     mod_n = mod(mod_i, length(Colors)) + 1;
%     p(mod_i).Color = Colors{mod_n};
%     p(mod_i).Marker = Markers{mod_m};
% end
hold off;
axis([0 210 -3 3]);
modal_name_tPSC = strrep(fieldnames(tPSCdata_sub),'_','\_');
legend(modal_name_tPSC);
title(name);
if savefiles == 1
    saveas(gcf,savename);
end

close(fig_results);
end