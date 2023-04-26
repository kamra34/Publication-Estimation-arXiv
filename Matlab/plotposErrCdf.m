function [val,prob] = plotposErrCdf(posErr)

temp= [];
for jj=1:size(posErr,2)
   temp= [temp;posErr(:,jj)]; 
end

[~,val,prob] = cdfplin(temp(:),'r-',0:0.1:100,0);
% 
% figure();plotfix(); hold all;
% h1 = plot(val,prob,'LineWidth',2,'Color',[0 0 1]);
% 
% NameArray = {'LineStyle','Color'};
% ValueArray = {'--','red'};
% set([h1],NameArray,ValueArray)
% 
% % legend([h1],'CDF')
% grid on
% box on
% ylabel('CDF','FontWeight','bold'); xlabel('Horizontal Positioning Error [m]', 'FontWeight', 'bold');
% simOut.nFig = simOut.nFig + 1;
end