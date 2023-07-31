function mean_Dice_list = Plot_Save_Dice(Parameter, Dice,modality)

linewidth = 1;
fontsize = 20;

mean_Dice_list = [];
ROInames = fieldnames(Dice);
for namei = 1:length(ROInames)
    Dicemodal = Dice.(ROInames{namei});
    for modali = 1:length(modality)
        mean_Dice_list(namei,modali) = mean(cat(1,Dicemodal.(modality{modali})));
    end
end

scrsz = get(0,'ScreenSize');
fig_results = figure('Position',[0 30 scrsz(3) scrsz(4)-95]);
bar(mean_Dice_list);
legend(strrep(modality,'_','\_'));
set(gca,'XTickLabel',strrep(ROInames,'_','\_'),'fontsize',fontsize-8);
ylabel('Dice Coefficient','linewidth',linewidth,'fontsize',fontsize);
title('Seed-Based rs-fMRI Reproducibility','linewidth',linewidth,'fontsize',fontsize);

savename = fullfile(Parameter.dir_result ,'Dice.png');
saveas(gcf, savename);

close(fig_results);

end