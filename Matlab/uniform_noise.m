clear all; close all

%% This code corresponds to the comparison of BLUe and two MVU cases where
% for the case of uniform noise e(k) \sim U(0,b)

% -------------- Simulation parameters ----------------
Nmc = 100; %700; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size
ifSave = 0;
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
%         b = unifrnd(1,50,1,1); % maximum support of uniform
b=50;
        x0 = 10; % true parameter value
        
        
        e = unifrnd(0,b,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_(NmcIter) = blueEstimator(Nobs,y,b);
        xhatMvuKnown_(NmcIter) = mvuEstimatorKnown(Nobs,y,b);
        xhatMvuUnknown_(NmcIter) = mvuEstimatorUnknown(Nobs,y,b);
        xhatMin_(NmcIter) = minEstimator(Nobs,y,b);
        
       theoreticalVarBlue_(NobsIter,NmcIter) = b^2 / (12*Nobs);
       theoreticalVarMvuKnown_(NobsIter,NmcIter) = (b^2) / (4+(2*Nobs*(Nobs+3)));
       theoreticalVarMvuUnknown_(NobsIter,NmcIter) = (Nobs*b^2) / ((Nobs+2) * (Nobs^2 - 1));
       theoreticalVarMin_(NobsIter,NmcIter) = (2*b^2) / ((Nobs+2) * (Nobs + 1));
        
    end % NmcIter
    
    xhatBlue = mean(xhatBlue_);
    xhatMvuKnown = mean(xhatMvuKnown_);
    xhatMvuUnknown = mean(xhatMvuUnknown_);
    xhatMin = mean(xhatMin_);
    biasBlue = xhatBlue - x0;
    biasMvuKnown = xhatMvuKnown - x0;
    biasMvuUnknown = xhatMvuUnknown - x0;
    biasMin = xhatMin - x0;
    varBlue =  sum((xhatBlue_ - xhatBlue).^2)/Nmc;
    varMvuKnown =  sum((xhatMvuKnown_ - xhatMvuKnown).^2)/Nmc;
    varMvuUnknown =  sum((xhatMvuUnknown_ - xhatMvuUnknown).^2)/Nmc;
    varMin =  sum((xhatMin_ - xhatMin).^2)/Nmc;
    
    mseBlue(NobsIter) = varBlue + biasBlue^2;
    mseMvuKnown(NobsIter) = varMvuKnown + biasMvuKnown^2;
    mseMvuUnknown(NobsIter) = varMvuUnknown + biasMvuUnknown^2;
    mseMin(NobsIter) = varMin + biasMin^2;
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarMvuKnown(NobsIter) = mean(theoreticalVarMvuKnown_(NobsIter,:));
    theoreticalVarMvuUnknown(NobsIter) = mean(theoreticalVarMvuUnknown_(NobsIter,:));
    theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter





figUnif = plotLines(NobsVec,'uniform', ...
    mseBlue,mseMvuKnown,mseMvuUnknown,mseMin, ...
    theoreticalVarBlue, theoreticalVarMvuKnown, ...
    theoreticalVarMvuUnknown, theoreticalVarMin);



if ifSave
    figName = 'estimationMse_unif';
    saveas(figUnif,['../report_arxiv/fig/' figName '.fig'])
    saveas(figUnif,['../report_arxiv/fig/' figName '.eps'],'epsc')
end















