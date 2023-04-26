clear all; close all

%% This code corresponds to the comparison of BLUe and order statistics
% for the case of uniform noise e(k) \sim rayleigh(beta)

% -------------- Simulation parameters ----------------
Nmc = 2000; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size
ifSave = 0;
% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,b) ((1/N)*sum(y) - (b*sqrt(pi/2)));
% order estimator known hyperparameter
orderEstimatorKnown = @(N,y,b) (min(y) - ((b*sqrt(pi))/(sqrt(2*N))));
% order estimator unknown hyperparameter
orderEstimatorUnknown = @(N,y,b) sqrt(N)*min(y)/(sqrt(N)-1) - (sum(y)/(N*(sqrt(N)-1)));
% biased minimum order statistic estimator
minEstimator = @(N,y,b) (min(y));

for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
%     rng(4,'twister')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
        beta = 12; % maximum support of uniform
        x0 = 10; % true parameter value
        
        
        e = raylrnd(beta,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_(NmcIter) = blueEstimator(Nobs,y,beta);
        xhatOrderKnown_(NmcIter) = orderEstimatorKnown(Nobs,y,beta);
        xhatOrderUnknown_(NmcIter) = orderEstimatorUnknown(Nobs,y,beta);
        xhatMin_(NmcIter) = minEstimator(Nobs,y,beta);
        
       theoreticalVarBlue_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderKnown_(NobsIter,NmcIter) = (beta^2*(4-pi)) / (2*Nobs);
       theoreticalVarOrderUnknown_(NobsIter,NmcIter) = (beta^2*(4-pi)*(Nobs+1)) / (2*Nobs^2);
theoreticalVarMin_(NobsIter,NmcIter) = (2*beta^2) / (Nobs);
        
    end % NmcIter
    
        xhatBlue = mean(xhatBlue_);
    xhatOrderKnown = mean(xhatOrderKnown_);
    xhatOrderUnknown = mean(xhatOrderUnknown_);
    xhatMin = mean(xhatMin_);
    biasBlue = xhatBlue - x0;
    biasMvuKnown = xhatOrderKnown - x0;
    biasMvuUnknown = xhatOrderUnknown - x0;
    biasMin = xhatMin - x0;
    varBlue =  sum((xhatBlue_ - xhatBlue).^2)/Nmc;
    varMvuKnown =  sum((xhatOrderKnown_ - xhatOrderKnown).^2)/Nmc;
    varMvuUnknown =  sum((xhatOrderUnknown_ - xhatOrderUnknown).^2)/Nmc;
    varMin =  sum((xhatMin_ - xhatMin).^2)/Nmc;
    
    mseBlue(NobsIter) = varBlue + biasBlue^2;
    mseMvuKnown(NobsIter) = varMvuKnown + biasMvuKnown^2;
    mseMvuUnknown(NobsIter) = varMvuUnknown + biasMvuUnknown^2;
    mseMin(NobsIter) = varMin + biasMin^2;
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarOrderKnown(NobsIter) = mean(theoreticalVarOrderKnown_(NobsIter,:));
    theoreticalVarOrderUnknown(NobsIter) = mean(theoreticalVarOrderUnknown_(NobsIter,:));
theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter


figRay = plotLines(NobsVec,'rayleigh', ...
    mseBlue,mseMvuKnown,mseMvuUnknown,mseMin, ...
    theoreticalVarBlue, theoreticalVarOrderKnown, ...
    theoreticalVarOrderUnknown, theoreticalVarMin);



if ifSave
    figName = 'estimationMse_rayleigh';
    saveas(figRay,['../report_arxiv/fig/' figName '.fig'])
    saveas(figRay,['../report_arxiv/fig/' figName '.eps'],'epsc')
end

figRay2 = plotLines2(NobsVec,'rayleigh', ...
    mseBlue,mseMvuKnown,mseMvuUnknown,mseMin, ...
    theoreticalVarBlue, theoreticalVarOrderKnown, ...
    theoreticalVarOrderUnknown, theoreticalVarMin);



if ifSave
    figName = 'estimationMse_rayleigh_zoom';
    saveas(figRay2,['../report_arxiv/fig/' figName '.fig'])
    saveas(figRay2,['../report_arxiv/fig/' figName '.eps'],'epsc')
end









