clear all; close all
%% This code corresponds to the comparison of BLUe and order statistics
% for the case of uniform noise e(k) \sim a N(0,sigma) + (1-a)U[0,b]
% 
% % -------------- Simulation parameters ----------------
% Nmc = 1500; % number of MC run
% NobsVec = 2:5:2000; % data sample size
% alpha1 = 0.01; % mixture components
% alpha2 = 0.5; % mixture components
% alpha3 = 0.99; % mixture components
% 
% % -------------- Define estimators ----------------
% estimator = @(Na,ys) ys(Na);
% 
% for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
%     rng('default')
%     Nobs = NobsVec(NobsIter);
%     
%     for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
%         
%         % randomly generate b and x
%         std = unifrnd(1,8,1,1); %Normal std
%         b = unifrnd(1,50,1,1); % Uniform maximum support
%         x0 = unifrnd(-5,5,1,1); % true parameter value
%         U1 = rand(Nobs,1)<=alpha1; % U is true with probability p and false with probability 1-p
%         U2 = rand(Nobs,1)<=alpha2; % U is true with probability p and false with probability 1-p
%         U3 = rand(Nobs,1)<=alpha3; % U is true with probability p and false with probability 1-p
%         
%         e1 = (1-U1).*unifrnd(0,b,Nobs,1)+U1.*normrnd(0,std,Nobs,1);
%         y1 = x0 + e1; % generate the measurement vector
%         
%         e2 = (1-U2).*unifrnd(0,b,Nobs,1)+U2.*normrnd(0,std,Nobs,1);
%         y2 = x0 + e2; % generate the measurement vector
%         
%         e3 = (1-U3).*unifrnd(0,b,Nobs,1)+U3.*normrnd(0,std,Nobs,1);
%         y3 = x0 + e3; % generate the measurement vector
%         
%         % all estimators
%         Na1_1 = floor(Nobs*alpha1/2)+1;
% %         Na1_2 = ceil(Nobs*alpha1/2)-1+1;
%         Na2 = floor(Nobs*alpha2/2)+1;
%         Na3 = floor(Nobs*alpha3/2)+1;
%         xhat1 = estimator(Na1_1,sort(y1));
%         xhat2 = estimator(Na2,sort(y2));
%         xhat3 = estimator(Na3,sort(y3));
% %         xhat4 = estimator(Na1_2,sort(y1));
%         
%         % simulation variances in each mc iteration
%         var1_(NobsIter,NmcIter) = (xhat1-x0)^2;
%         var2_(NobsIter,NmcIter) = (xhat2-x0)^2;
%         var3_(NobsIter,NmcIter) = (xhat3-x0)^2;
% %         var4_(NobsIter,NmcIter) = (xhat4-x0)^2;
%         
%         % simulation bias in each mc iteration
%         bias1_(NobsIter,NmcIter) = (xhat1-x0);
%         bias2_(NobsIter,NmcIter) = (xhat2-x0);
%         bias3_(NobsIter,NmcIter) = (xhat3-x0);
% %         bias4_(NobsIter,NmcIter) = (xhat4-x0);
%     end % NmcIter
%     
%     % simulation variance after Nmc iterations for each sample size
%     var1(NobsIter) = mean(var1_(NobsIter,:));
%     var2(NobsIter) = mean(var2_(NobsIter,:));
%     var3(NobsIter) = mean(var3_(NobsIter,:));
% %     var4(NobsIter) = mean(var4_(NobsIter,:));
%     
%     % simulation bias after Nmc iterations for each sample size
%     bias1(NobsIter) = mean(bias1_(NobsIter,:));
%     bias2(NobsIter) = mean(bias2_(NobsIter,:));
%     bias3(NobsIter) = mean(bias3_(NobsIter,:));
% %     bias4(NobsIter) = mean(bias4_(NobsIter,:));
% end % NobsIter
% 
% save mixture_data_Nmc1500
%%
clear all;
load mixture_data_Nmc1500
uplim = 1-0.9;
lolim = 1-0.4;

for NobsIter=1:length(NobsVec)
    Var1sd(NobsIter,:) = sort(var1_(NobsIter,:),'descend'); % Sort Descending
    Var1sa(NobsIter,:) = sort(var1_(NobsIter,:),'ascend'); % Sort Descending
    Var2sd(NobsIter,:) = sort(var2_(NobsIter,:),'descend'); % Sort Descending
    Var2sa(NobsIter,:) = sort(var2_(NobsIter,:),'ascend'); % Sort Descending
    Var3sd(NobsIter,:) = sort(var3_(NobsIter,:),'descend'); % Sort Descending
    Var3sa(NobsIter,:) = sort(var3_(NobsIter,:),'ascend'); % Sort Descending
%     Var4sd(NobsIter,:) = sort(var4_(NobsIter,:),'descend'); % Sort Descending
%     Var4sa(NobsIter,:) = sort(var4_(NobsIter,:),'ascend'); % Sort Descending
    uboundVar1 = Var1sd(NobsIter,1:ceil(length(Var1sd(NobsIter,:))*uplim)); % Desired Output
    lboundVar1 = Var1sa(NobsIter,1:ceil(length(Var1sa(NobsIter,:))*lolim)); % Desired Output
    uboundVar2 = Var2sd(NobsIter,1:ceil(length(Var2sd(NobsIter,:))*uplim)); % Desired Output
    lboundVar2 = Var2sa(NobsIter,1:ceil(length(Var2sa(NobsIter,:))*lolim)); % Desired Output
    uboundVar3 = Var3sd(NobsIter,1:ceil(length(Var3sd(NobsIter,:))*uplim)); % Desired Output
    lboundVar3 = Var3sa(NobsIter,1:ceil(length(Var3sa(NobsIter,:))*lolim)); % Desired Output
%     uboundVar4 = Var4sd(NobsIter,1:ceil(length(Var4sd(NobsIter,:))*uplim)); % Desired Output
%     lboundVar4 = Var4sa(NobsIter,1:ceil(length(Var4sa(NobsIter,:))*lolim)); % Desired Output
    var1Plot = var1_(NobsIter,:);
    var1Plot = setdiff(var1Plot,uboundVar1);
    var1Plot = setdiff(var1Plot,lboundVar1);
    var2Plot = var2_(NobsIter,:);
    var2Plot = setdiff(var2Plot,uboundVar2);
    var2Plot = setdiff(var2Plot,lboundVar2);
    var3Plot = var3_(NobsIter,:);
    var3Plot = setdiff(var3Plot,uboundVar3);
    var3Plot = setdiff(var3Plot,lboundVar3);
%     var4Plot = var4_(NobsIter,:);
%     var4Plot = setdiff(var4Plot,uboundVar4);
%     var4Plot = setdiff(var4Plot,lboundVar4);
    Var1Plot(NobsIter,:) = var1Plot;
    Var2Plot(NobsIter,:) = var2Plot;
    Var3Plot(NobsIter,:) = var3Plot;
%     Var4Plot(NobsIter,:) = var4Plot;
end % NobsIter

figure1 = figure;
plotfix()
axes1 = axes('Parent',figure1);
hold(axes1,'on');

h1 = semilogy(NobsVec,Var1Plot,'.','MarkerSize',0.5,'Color',[0.87,0.92,0.98]);
h3 = semilogy(NobsVec,Var2Plot,'.','MarkerSize',0.5,'Color',[0.89,0.94,0.9]);
h5 = semilogy(NobsVec,Var3Plot,'.','MarkerSize',0.5,'Color',[0.96,0.92,0.92]);
% h7 = semilogy(NobsVec,Var4Plot,'k.','MarkerSize',0.5);
% h1 = semilogy(NobsVec,Var1Plot,'.','MarkerSize',0.5,'Color',[0.87,0.92,0.98]);
% h3 = semilogy(NobsVec,varmvuKnown,'rx','MarkerSize',6);
h2 = semilogy(NobsVec,var1,'-','LineWidth',3,'Color',[0.31,0.4,0.58]);
h4 = semilogy(NobsVec,var2,'-','LineWidth',3,'Color',[0.16,0.38,0.27]);
h6 = semilogy(NobsVec,var3,'-','LineWidth',3,'Color',[0.64,0.08,0.18]);
% h8 = semilogy(NobsVec,var4,'-','LineWidth',3,'Color',[0.49,0.49,0.49]);
% LEG = legend([h2,h8,h4,h6],{'$\alpha=0.01, max(1,\lfloor\frac{N\alpha}{2}\rfloor)$','$\alpha=0.01, \lceil\frac{N\alpha}{2}\rceil$','$\alpha=0.5$','$\alpha=0.99$'},'Interpreter','latex');
LEG = legend([h2,h4,h6],{'$a=0.01$','$a=0.5$','$a=0.99$'},'Interpreter','latex');
LEG.FontSize = 16;
set(axes1,'YMinorTick','on','YScale','log');
set(axes1,'XMinorTick','on');
box on
grid on
% xlim([NobsVec(1) NobsVec(end)])
xlim([-15 2020])
xlabel('Sample size','FontSize',16)
ylabel('Variance','FontSize',16)
% Set the remaining axes properties
set(axes1,'XMinorTick','on','XTick',...
    [2 200 400 600 800 1000 1200 1400 1600 1800 2000],'XTickLabel',...
    {'2','200','400','600','800','1000','1200','1400','1600','1800','2000'},...
    'YMinorTick','on','YScale','log');


figure2 = figure;
plotfix()
axes1 = axes('Parent',figure2);
hold(axes1,'on');

h2 = semilogy(NobsVec,bias1,'-','LineWidth',4,'Color',[0.31,0.4,0.58]);
h4 = semilogy(NobsVec,bias2,'-','LineWidth',4,'Color',[0.16,0.38,0.27]);
h6 = semilogy(NobsVec,bias3,'-','LineWidth',4,'Color',[0.64,0.08,0.18]);
% h8 = semilogy(NobsVec,bias4,'-','LineWidth',3,'Color','black');
LEG = legend([h2,h4,h6],{'$a=0.01$','$a=0.5$','$a=0.99$'},'Interpreter','latex');
LEG.FontSize = 16;
% set(axes1,'YMinorTick','on','YScale','log');
% set(axes1,'XMinorTick','on');
box on
grid on
% xlim([NobsVec(1) NobsVec(end)])
xlim([-15 2020])
xlabel('Sample size','FontSize',16)
ylabel('Bias','FontSize',16)
% Set the remaining axes properties
set(axes1,'XMinorTick','on','XTick',...
     [2 200 400 600 800 1000 1200 1400 1600 1800 2000],'XTickLabel',...
     {'2','200','400','600','800','1000','1200','1400','1600','1800','2000'})%,...
%     'YMinorTick','on','YScale','log');







