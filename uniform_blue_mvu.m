clear all; close all

%% This code corresponds to the comparison of BLUe and two MVU cases where
% for the case of uniform noise e(k) \sim U(0,b)

% -------------- Simulation parameters ----------------
Nmc = 50; %700; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size
% -------------- Define two estimators ----------------
% Blue estimator
blueEstimator = @(N,y,b) ((1/N)*sum(y) - b/2);
% MVU estimator known hyperparameter
mvuEstimatorKnown = @(N,y,b) (min(y)+max(y))/2 - (b/2);
% MVU estimator unknown hyperparameter
mvuEstimatorUnknown = @(N,y,b) (min(y)*N/(N-1)) - (max(y)/(N-1));
% biased minimum order statistic estimator
minEstimator = @(N,y,b) (min(y));

for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    rng('default')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
        b = unifrnd(1,50,1,1); % maximum support of uniform
        x0 = unifrnd(-5,5,1,1); % true parameter value
        
        
        e = unifrnd(0,b,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_ = blueEstimator(Nobs,y,b);
        xhatMvuKnown_ = mvuEstimatorKnown(Nobs,y,b);
        xhatMvuUnknown_ = mvuEstimatorUnknown(Nobs,y,b);
        xhatMin_ = minEstimator(Nobs,y,b);
        
        % simulation variances in each mc iteration
        varBlue_(NobsIter,NmcIter) = (xhatBlue_-x0)^2; 
        varMvuKnown_(NobsIter,NmcIter) = (xhatMvuKnown_-x0)^2;
        varMvuUnknown_(NobsIter,NmcIter) = (xhatMvuUnknown_-x0)^2;
        varMin_(NobsIter,NmcIter) = (xhatMin_-x0)^2;
        
       theoreticalVarBlue_(NobsIter,NmcIter) = b^2 / (12*Nobs);
       theoreticalVarMvuKnown_(NobsIter,NmcIter) = (b^2) / (4+(2*Nobs*(Nobs+3)));
       theoreticalVarMvuUnknown_(NobsIter,NmcIter) = (Nobs*b^2) / ((Nobs+2) * (Nobs^2 - 1));
       theoreticalVarMin_(NobsIter,NmcIter) = (2*b^2) / ((Nobs+2) * (Nobs + 1));
        
    end % NmcIter
    
    % simulation variance after Nmc iterations for each sample size
    varBlue(NobsIter) = mean(varBlue_(NobsIter,:));
    varmvuKnown(NobsIter) = mean(varMvuKnown_(NobsIter,:));
    varmvuUnknown(NobsIter) = mean(varMvuUnknown_(NobsIter,:));
    varMin(NobsIter) = mean(varMin_(NobsIter,:));
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarMvuKnown(NobsIter) = mean(theoreticalVarMvuKnown_(NobsIter,:));
    theoreticalVarMvuUnknown(NobsIter) = mean(theoreticalVarMvuUnknown_(NobsIter,:));
    theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter

uplim = 1-0.9;
lolim = 1-0.3;

for NobsIter=1:length(NobsVec)
blueVarsd(NobsIter,:) = sort(varBlue_(NobsIter,:),'descend'); % Sort Descending
blueVarsa(NobsIter,:) = sort(varBlue_(NobsIter,:),'ascend'); % Sort Descending
MvuKnownVarsd(NobsIter,:) = sort(varMvuKnown_(NobsIter,:),'descend'); % Sort Descending
MvuKnownVarsa(NobsIter,:) = sort(varMvuKnown_(NobsIter,:),'ascend'); % Sort Descending
MvuUnknownVarsd(NobsIter,:) = sort(varMvuUnknown_(NobsIter,:),'descend'); % Sort Descending
MvuUnknownVarsa(NobsIter,:) = sort(varMvuUnknown_(NobsIter,:),'ascend'); % Sort Descending
MinVarsd(NobsIter,:) = sort(varMin_(NobsIter,:),'descend'); % Sort Descending
MinVarsa(NobsIter,:) = sort(varMin_(NobsIter,:),'ascend'); % Sort Descending
uboundBlue = blueVarsd(NobsIter,1:ceil(length(blueVarsd(NobsIter,:))*uplim)); % Desired Output
lboundBlue = blueVarsa(NobsIter,1:ceil(length(blueVarsa(NobsIter,:))*0.6)); % Desired Output
uboundMvuKnown = MvuKnownVarsd(NobsIter,1:ceil(length(MvuKnownVarsd(NobsIter,:))*uplim)); % Desired Output
lboundMvuKnown = MvuKnownVarsa(NobsIter,1:ceil(length(MvuKnownVarsa(NobsIter,:))*lolim)); % Desired Output
uboundMvuUnknown = MvuUnknownVarsd(NobsIter,1:ceil(length(MvuUnknownVarsd(NobsIter,:))*uplim)); % Desired Output
lboundMvuUnknown = MvuUnknownVarsa(NobsIter,1:ceil(length(MvuUnknownVarsa(NobsIter,:))*lolim)); % Desired Output
uboundMin = MinVarsd(NobsIter,1:ceil(length(MinVarsd(NobsIter,:))*0.1)); % Desired Output
lboundMin = MinVarsa(NobsIter,1:ceil(length(MinVarsa(NobsIter,:))*0.6)); % Desired Output
varPlotBlue = varBlue_(NobsIter,:);
varPlotBlue = setdiff(varPlotBlue,uboundBlue);
varPlotBlue = setdiff(varPlotBlue,lboundBlue);
varPlotMvuKnown = varMvuKnown_(NobsIter,:);
varPlotMvuKnown = setdiff(varPlotMvuKnown,uboundMvuKnown);
varPlotMvuKnown = setdiff(varPlotMvuKnown,lboundMvuKnown);
varPlotMvuUnknown = varMvuUnknown_(NobsIter,:);
varPlotMvuUnknown = setdiff(varPlotMvuUnknown,uboundMvuUnknown);
varPlotMvuUnknown = setdiff(varPlotMvuUnknown,lboundMvuUnknown);
varPlotMin = varMin_(NobsIter,:);
varPlotMin = setdiff(varPlotMin,uboundMin);
varPlotMin = setdiff(varPlotMin,lboundMin);
blueVarPlot(NobsIter,:) = varPlotBlue;
MvuKnownVarPlot(NobsIter,:) = varPlotMvuKnown;
MvuUnknownVarPlot(NobsIter,:) = varPlotMvuUnknown;
MinVarPlot(NobsIter,:) = varPlotMin;
end % NobsIter

%%
figure1 = figure;
plotfix()
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% h1 = semilogy(NobsVec,varBlue,'bx','MarkerSize',6);
h1 = semilogy(NobsVec,blueVarPlot,'.','MarkerSize',0.5,'Color',[0.87,0.92,0.98]);
% h3 = semilogy(NobsVec,varMin,'gx','MarkerSize',6);
h3 = semilogy(NobsVec,MinVarPlot,'.','MarkerSize',0.5,'Color',[0.91,0.91,0.91]);
% h5 = semilogy(NobsVec,varmvuUnknown,'kx','MarkerSize',6);
h5 = semilogy(NobsVec,MvuUnknownVarPlot,'.','MarkerSize',0.5,'Color',[0.96,0.92,0.92]);
% h7 = semilogy(NobsVec,varmvuKnown,'rx','MarkerSize',6);
h7 = semilogy(NobsVec,MvuKnownVarPlot,'.','MarkerSize',0.5,'Color',[0.89,0.94,0.9]);

h2 = semilogy(NobsVec,theoreticalVarBlue,'-','LineWidth',3,'Color',[0.31,0.4,0.58]);
h4 = semilogy(NobsVec,theoreticalVarMin,'-','LineWidth',3,'Color','black');
h6 = semilogy(NobsVec,theoreticalVarMvuUnknown,'-','LineWidth',3,'Color',[0.64,0.08,0.18]);
h8 = semilogy(NobsVec,theoreticalVarMvuKnown,'-','LineWidth',3,'Color',[0.16,0.38,0.27]);
LEG = legend([h2,h4,h6,h8],{'$\hat{x}_{\mathrm{BLUE}}$','$\hat{x}_{\mathrm{min}}$','$\hat{x}_{\mathrm{MVU}}$, unknown hyper parameter','$\hat{x}_{\mathrm{MVU}}$, known hyper parameter'},'Interpreter','latex');
LEG.FontSize = 16;
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

