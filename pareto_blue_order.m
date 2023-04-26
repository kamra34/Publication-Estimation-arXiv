clear all; close all

%% This code corresponds to the comparison of BLUe and order statistics
% for the case of uniform noise e(k) \sim rayleigh(beta)

% -------------- Simulation parameters ----------------
Nmc = 1000; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size

% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,a,b) ((1/N)*sum(y) - ((a*b)/(a-1)));
% order estimator known hyperparameter
orderEstimatorKnown = @(N,y,a,b) (min(y) - ((N*a*b)/((N*a)-1)));
% biased minimum order statistic estimator
minEstimator = @(N,y,b) (min(y));
for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    rng('default')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
         beta = 0.5;%unifrnd(0.01,0.05,1,1); % maximum support of uniform
         alpha =unifrnd(3,3.5,1,1);
         x0 = unifrnd(-5,5,1,1); % true parameter value
        
        
        e = randp(Nobs,1,alpha,beta);% generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_ = blueEstimator(Nobs,y,alpha,beta);
        xhatOrderKnown_ = orderEstimatorKnown(Nobs,y,alpha,beta);
        xhatMin_ = minEstimator(Nobs,y,beta);
        % simulation variances in each mc iteration
        varBlue_(NobsIter,NmcIter) = (xhatBlue_-x0)^2; 
        varOrderKnown_(NobsIter,NmcIter) = (xhatOrderKnown_-x0)^2;
         varMin_(NobsIter,NmcIter) = (xhatMin_-x0)^2;
       theoreticalVarBlue_(NobsIter,NmcIter) = (alpha*beta^2) / (Nobs*(alpha-1)^2 * (alpha-2));
       theoreticalVarOrderKnown_(NobsIter,NmcIter) = (Nobs*alpha*beta^2) / ((Nobs*alpha-1)^2 * (Nobs*alpha-2));
        theoreticalVarMin_(NobsIter,NmcIter) = (Nobs*alpha*beta^2) /(Nobs*alpha-2);
    end % NmcIter
    
    % simulation variance after Nmc iterations for each sample size
    varBlue(NobsIter) = mean(varBlue_(NobsIter,:));
    varorderKnown(NobsIter) = mean(varOrderKnown_(NobsIter,:));
    varMin(NobsIter) = mean(varMin_(NobsIter,:));
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarOrderKnown(NobsIter) = mean(theoreticalVarOrderKnown_(NobsIter,:));
    theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter

uplim = 1-0.9;
lolim = 1-0.3;

for NobsIter=1:length(NobsVec)
blueVarsd(NobsIter,:) = sort(varBlue_(NobsIter,:),'descend'); % Sort Descending
blueVarsa(NobsIter,:) = sort(varBlue_(NobsIter,:),'ascend'); % Sort Descending
OrderKnownVarsd(NobsIter,:) = sort(varOrderKnown_(NobsIter,:),'descend'); % Sort Descending
OrderKnownVarsa(NobsIter,:) = sort(varOrderKnown_(NobsIter,:),'ascend'); % Sort Descending
MinVarsd(NobsIter,:) = sort(varMin_(NobsIter,:),'descend'); % Sort Descending
MinVarsa(NobsIter,:) = sort(varMin_(NobsIter,:),'ascend'); % Sort Descending
uboundBlue = blueVarsd(NobsIter,1:ceil(length(blueVarsd(NobsIter,:))*uplim)); % Desired Output
lboundBlue = blueVarsa(NobsIter,1:ceil(length(blueVarsa(NobsIter,:))*0.4)); % Desired Output
uboundOrderKnown = OrderKnownVarsd(NobsIter,1:ceil(length(OrderKnownVarsd(NobsIter,:))*uplim)); % Desired Output
lboundOrderKnown = OrderKnownVarsa(NobsIter,1:ceil(length(OrderKnownVarsa(NobsIter,:))*0.5)); % Desired Output
uboundMin = MinVarsd(NobsIter,1:ceil(length(MinVarsd(NobsIter,:))*uplim)); % Desired Output
lboundMin = MinVarsa(NobsIter,1:ceil(length(MinVarsa(NobsIter,:))*lolim)); % Desired OutputOutput
varPlotBlue = varBlue_(NobsIter,:);
varPlotBlue = setdiff(varPlotBlue,uboundBlue);
varPlotBlue = setdiff(varPlotBlue,lboundBlue);
varPlotOrderKnown = varOrderKnown_(NobsIter,:);
varPlotOrderKnown = setdiff(varPlotOrderKnown,uboundOrderKnown);
varPlotOrderKnown = setdiff(varPlotOrderKnown,lboundOrderKnown);
varPlotMin = varMin_(NobsIter,:);
% varPlotMin = setdiff(varPlotMin,uboundMin);
% varPlotMin = setdiff(varPlotMin,lboundMin);
blueVarPlot(NobsIter,:) = varPlotBlue;
OrderKnownVarPlot(NobsIter,:) = varPlotOrderKnown;
MinVarPlot(NobsIter,:) = varPlotMin;
end % NobsIter

%%
figure1 = figure;
plotfix()
axes1 = axes('Parent',figure1);
hold(axes1,'on');

h1 = semilogy(NobsVec,blueVarPlot,'.','MarkerSize',0.5,'Color',[0.87,0.92,0.98]);
h3 = semilogy(NobsVec,MinVarPlot,'.','MarkerSize',0.5,'Color',[0.91,0.91,0.91]); 
h5 = semilogy(NobsVec,OrderKnownVarPlot,'.','MarkerSize',0.5,'Color',[0.89,0.94,0.9]);


h2 = semilogy(NobsVec,theoreticalVarBlue,'-','LineWidth',3,'Color',[0.31,0.4,0.58]);
h4 = semilogy(NobsVec,theoreticalVarMin,'-','LineWidth',3,'Color','black');
h6 = semilogy(NobsVec,theoreticalVarOrderKnown,'-','LineWidth',3,'Color',[0.16,0.38,0.27]);

LEG = legend([h2,h4,h6],{'$\hat{x}_{\mathrm{BLUE}}$','$\hat{x}_{\mathrm{min}}$','$\hat{x}_{\mathrm{order}}$, known hyper parameter'},'Interpreter','latex');
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
xlim([-15 2117])
set(axes1,'XMinorTick','on','XTick',...
    [2 300 600 900 1200 1500 1800 2100],'XTickLabel',...
    {'2','300','600','900','1200','1500','1800','2100'},...
    'YMinorTick','on','YScale','log');
