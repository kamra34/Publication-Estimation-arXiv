clear all; close all

%% This code corresponds to the comparison of BLUe and order statistics
% for the case of uniform noise e(k) \sim rayleigh(beta)

% -------------- Simulation parameters ----------------
Nmc = 1000; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size

% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,b) ((1/N)*sum(y) - (b*sqrt(pi/2)));
% order estimator known hyperparameter
orderEstimatorKnown = @(N,y,b) (min(y) - ((b*sqrt(pi))/(sqrt(2*N))));
% order estimator unknown hyperparameter
orderEstimatorUnknown = @(N,y,b) min(y) - (sum(y)/(N*sqrt(N)));
% biased minimum order statistic estimator
minEstimator = @(N,y,b) (min(y));

for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    rng('default')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
        beta = unifrnd(1,12,1,1); % maximum support of uniform
        x0 = unifrnd(-5,5,1,1); % true parameter value
        
        
        e = raylrnd(beta,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_ = blueEstimator(Nobs,y,beta);
        xhatOrderKnown_ = orderEstimatorKnown(Nobs,y,beta);
        xhatOrderUnknown_ = orderEstimatorUnknown(Nobs,y,beta);
        xhatMin_ = minEstimator(Nobs,y,beta);
        
        % simulation variances in each mc iteration
        varBlue_(NobsIter,NmcIter) = (xhatBlue_-x0)^2; 
        varOrderKnown_(NobsIter,NmcIter) = (xhatOrderKnown_-x0)^2;
        varOrderUnknown_(NobsIter,NmcIter) = (xhatOrderUnknown_-x0)^2;
        varMin_(NobsIter,NmcIter) = (xhatMin_-x0)^2;
        
       theoreticalVarBlue_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderKnown_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderUnknown_(NobsIter,NmcIter) = (beta^2*(4-pi)*(Nobs+1)) / (2*Nobs^2);
theoreticalVarMin_(NobsIter,NmcIter) = (2*beta^2) / (Nobs);
        
    end % NmcIter
    
    % simulation variance after Nmc iterations for each sample size
    varBlue(NobsIter) = mean(varBlue_(NobsIter,:));
    varorderKnown(NobsIter) = mean(varOrderKnown_(NobsIter,:));
    varorderUnknown(NobsIter) = mean(varOrderUnknown_(NobsIter,:));
varMin(NobsIter) = mean(varMin_(NobsIter,:));
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarOrderKnown(NobsIter) = mean(theoreticalVarOrderKnown_(NobsIter,:));
    theoreticalVarOrderUnknown(NobsIter) = mean(theoreticalVarOrderUnknown_(NobsIter,:));
theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter
%%
uplim = 1-0.9;
lolim = 1-0.5;

for NobsIter=1:length(NobsVec)
blueVarsd(NobsIter,:) = sort(varBlue_(NobsIter,:),'descend'); % Sort Descending
blueVarsa(NobsIter,:) = sort(varBlue_(NobsIter,:),'ascend'); % Sort Descending
OrderKnownVarsd(NobsIter,:) = sort(varOrderKnown_(NobsIter,:),'descend'); % Sort Descending
OrderKnownVarsa(NobsIter,:) = sort(varOrderKnown_(NobsIter,:),'ascend'); % Sort Descending
OrderUnknownVarsd(NobsIter,:) = sort(varOrderUnknown_(NobsIter,:),'descend'); % Sort Descending
OrderUnknownVarsa(NobsIter,:) = sort(varOrderUnknown_(NobsIter,:),'ascend'); % Sort Descending
MinVarsd(NobsIter,:) = sort(varMin_(NobsIter,:),'descend'); % Sort Descending
MinVarsa(NobsIter,:) = sort(varMin_(NobsIter,:),'ascend'); % Sort Descending
uboundBlue = blueVarsd(NobsIter,1:ceil(length(blueVarsd(NobsIter,:))*uplim)); % Desired Output
lboundBlue = blueVarsa(NobsIter,1:ceil(length(blueVarsa(NobsIter,:))*lolim)); % Desired Output
uboundOrderKnown = OrderKnownVarsd(NobsIter,1:ceil(length(OrderKnownVarsd(NobsIter,:))*uplim)); % Desired Output
lboundOrderKnown = OrderKnownVarsa(NobsIter,1:ceil(length(OrderKnownVarsa(NobsIter,:))*lolim)); % Desired Output
uboundOrderUnknown = OrderUnknownVarsd(NobsIter,1:ceil(length(OrderUnknownVarsd(NobsIter,:))*uplim)); % Desired Output
lboundOrderUnknown = OrderUnknownVarsa(NobsIter,1:ceil(length(OrderUnknownVarsa(NobsIter,:))*0.4)); % Desired
uboundMin = MinVarsd(NobsIter,1:ceil(length(MinVarsd(NobsIter,:))*0.1)); % Desired Output
lboundMin = MinVarsa(NobsIter,1:ceil(length(MinVarsa(NobsIter,:))*0.5)); % Desired OutputOutput
varPlotBlue = varBlue_(NobsIter,:);
varPlotBlue = setdiff(varPlotBlue,uboundBlue);
varPlotBlue = setdiff(varPlotBlue,lboundBlue);
varPlotOrderKnown = varOrderKnown_(NobsIter,:);
varPlotOrderKnown = setdiff(varPlotOrderKnown,uboundOrderKnown);
varPlotOrderKnown = setdiff(varPlotOrderKnown,lboundOrderKnown);
varPlotOrderUnknown = varOrderUnknown_(NobsIter,:);
varPlotOrderUnknown = setdiff(varPlotOrderUnknown,uboundOrderUnknown);
varPlotOrderUnknown = setdiff(varPlotOrderUnknown,lboundOrderUnknown);
varPlotMin = varMin_(NobsIter,:);
varPlotMin = setdiff(varPlotMin,uboundMin);
varPlotMin = setdiff(varPlotMin,lboundMin);
blueVarPlot(NobsIter,:) = varPlotBlue;
OrderKnownVarPlot(NobsIter,:) = varPlotOrderKnown;
OrderUnknownVarPlot(NobsIter,:) = varPlotOrderUnknown;
MinVarPlot(NobsIter,:) = varPlotMin;
end % NobsIter

%%
figure1 = figure;
plotfix()
axes1 = axes('Parent',figure1);
hold(axes1,'on');

h1 = semilogy(NobsVec,blueVarPlot,'.','MarkerSize',0.5,'Color',[0.87,0.92,0.98]);
h3 = semilogy(NobsVec,MinVarPlot,'.','MarkerSize',0.5,'Color',[0.91,0.91,0.91]);
h5 = semilogy(NobsVec,OrderUnknownVarPlot,'.','MarkerSize',0.5,'Color',[0.96,0.92,0.92]);


h2 = semilogy(NobsVec,theoreticalVarBlue,'-','LineWidth',3,'Color',[0.31,0.4,0.58]);
h4 = semilogy(NobsVec,theoreticalVarMin,'-','LineWidth',3,'Color','black');
h6 = semilogy(NobsVec,theoreticalVarOrderUnknown,'-','LineWidth',3,'Color',[0.64,0.08,0.18]);


LEG = legend([h2,h4,h6],{'$\hat{x}_{\mathrm{BLUE}}$','$\hat{x}_{\mathrm{min}}$','$\hat{x}_{\mathrm{order}}$, unknown hyper parameter'},'Interpreter','latex');
LEG.FontSize = 14;
set(axes1,'YMinorTick','on','YScale','log');
set(axes1,'XMinorTick','on');
box on
grid on
% xlim([NobsVec(1) NobsVec(end)])
xlim([-15 2020])
xlabel('Sample size','FontSize',16)
ylabel('MSE','FontSize',16)
% Set the remaining axes properties
% set(axes1,'XMinorTick','on','XTick',...
%     [2 200 400 600 800 1000 1200 1400 1600 1800 2000],'XTickLabel',...
%     {'2','200','400','600','800','1000','1200','1400','1600','1800','2000'},...
%     'YMinorTick','on','YScale','log');
xlim([-15 2100])
set(axes1,'XMinorTick','on','XTick',...
    [2 300 600 900 1200 1500 1800 2100],'XTickLabel',...
    {'2','300','600','900','1200','1500','1800','2100'},...
    'YMinorTick','on','YScale','log');

%% 
% zoomed-in plot
clear all 

% -------------- Simulation parameters ----------------
Nmc = 2000; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:1:40; % data sample size

% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,b) ((1/N)*sum(y) - (b*sqrt(pi/2)));
% order estimator known hyperparameter
orderEstimatorKnown = @(N,y,b) (min(y) - ((b*sqrt(pi))/(sqrt(2*N))));
% order estimator unknown hyperparameter
orderEstimatorUnknown = @(N,y,b) min(y) - (sum(y)/(N*sqrt(N)));
% biased minimum order statistic estimator
minEstimator = @(N,y,b) (min(y));

for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    rng('default')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
        beta = unifrnd(1,12,1,1); % maximum support of uniform
        x0 = unifrnd(-5,5,1,1); % true parameter value
        
        
        e = raylrnd(beta,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_ = blueEstimator(Nobs,y,beta);
        xhatOrderKnown_ = orderEstimatorKnown(Nobs,y,beta);
        xhatOrderUnknown_ = orderEstimatorUnknown(Nobs,y,beta);
        xhatMin_ = minEstimator(Nobs,y,beta);
        
        % simulation variances in each mc iteration
        varBlue_(NobsIter,NmcIter) = (xhatBlue_-x0)^2; 
        varOrderKnown_(NobsIter,NmcIter) = (xhatOrderKnown_-x0)^2;
        varOrderUnknown_(NobsIter,NmcIter) = (xhatOrderUnknown_-x0)^2;
        varMin_(NobsIter,NmcIter) = (xhatMin_-x0)^2;
        
       theoreticalVarBlue_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderKnown_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderUnknown_(NobsIter,NmcIter) = (beta^2*(4-pi)*(Nobs+1)) / (2*Nobs^2);
theoreticalVarMin_(NobsIter,NmcIter) = (2*beta^2) / (Nobs);
        
    end % NmcIter
    
    % simulation variance after Nmc iterations for each sample size
    varBlue(NobsIter) = mean(varBlue_(NobsIter,:));
    varorderKnown(NobsIter) = mean(varOrderKnown_(NobsIter,:));
    varorderUnknown(NobsIter) = mean(varOrderUnknown_(NobsIter,:));
varMin(NobsIter) = mean(varMin_(NobsIter,:));
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarOrderKnown(NobsIter) = mean(theoreticalVarOrderKnown_(NobsIter,:));
    theoreticalVarOrderUnknown(NobsIter) = mean(theoreticalVarOrderUnknown_(NobsIter,:));
theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter

figure2 = figure;
plotfix()
axes1 = axes('Parent',figure2);
hold(axes1,'on');

h1 = semilogy(NobsVec,theoreticalVarBlue,'-','LineWidth',3,'Color',[0.31,0.4,0.58]);
h2 = semilogy(NobsVec,theoreticalVarMin,'-','LineWidth',3,'Color','black');
h3 = semilogy(NobsVec,theoreticalVarOrderUnknown,'-','LineWidth',3,'Color',[0.64,0.08,0.18]);

LEG = legend([h1,h2,h3],{'$\hat{x}_{\mathrm{BLUE}}$','$\hat{x}_{\mathrm{min}}$','$\hat{x}_{\mathrm{order}}$, unknown hyper parameter'},'Interpreter','latex');
LEG.FontSize = 14;
set(axes1,'YMinorTick','on','YScale','log');
set(axes1,'XMinorTick','on');
box on
grid on
% xlim([NobsVec(1) NobsVec(end)])
xlim([1.85 40])
xlabel('Sample size','FontSize',16)
ylabel('MSE','FontSize',16)
% Set the remaining axes properties
set(axes1,'XMinorTick','on','XTick',...
    [2 5 10 15 20 25 30 35 40],'XTickLabel',...
    {'2','5','10','15','20','25','30','35','40'},...
    'YMinorTick','on','YScale','log');