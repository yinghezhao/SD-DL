function Plot_Save_Results(struct_results,modal_name,dir_save_result,name,plotfunction)
savename = fullfile(dir_save_result,[name '.png']);
savefiles = 1;
table_results = table2array(struct2table(struct_results));

if exist(savename,'file')
    savefiles = 0;
    warning([name ' exists, original file will not be overwritten ']);
end

fig_results = figure(1);
title(name);
if isequal(plotfunction, 'boxplot') && savefiles == 1
    boxplot(table_results,modal_name);
    saveas(gcf,savename);
end

close(fig_results);
end