clear all; close all

%% This code corresponds to the comparison of BLUe and Mvu statistics
% for the case of uniform noise e(k) \sim rayleigh(beta)

% -------------- Simulation parameters ----------------
Nmc = 1000; % number of MC run
% NobsVec = [[2:50],[60:50:2000]]; % data sample size
NobsVec = 2:5:2103; % data sample size
ifSave = 1;
% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,a,b) ((1/N)*sum(y) - ((a*b)/(a-1)));
% Mvu estimator known hyperparameter
MvuEstimatorKnown = @(N,y,a,b) (min(y) - ((N*a*b)/((N*a)-1)));
% biased minimum Mvu statistic estimator
minEstimator = @(N,y,b) (min(y));
for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    rng('default')
    Nobs = NobsVec(NobsIter);
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
         beta = 6;%0.5;%unifrnd(0.01,0.05,1,1); % maximum support of uniform
         alpha = 2.5;%unifrnd(3,3.5,1,1);
         x0 = 10; % true parameter value
        
        
        e = randp(Nobs,1,alpha,beta);% generate the noise
        y = x0 + e; % generate the measurement vector
        
        % all estimators
        xhatBlue_(NmcIter) = blueEstimator(Nobs,y,alpha,beta);
        xhatMvuKnown_(NmcIter) = MvuEstimatorKnown(Nobs,y,alpha,beta);
        xhatMin_(NmcIter) = minEstimator(Nobs,y,beta);

       theoreticalVarBlue_(NobsIter,NmcIter) = (alpha*beta^2) / (Nobs*(alpha-1)^2 * (alpha-2));
       theoreticalVarMvuKnown_(NobsIter,NmcIter) = (Nobs*alpha*beta^2) / ((Nobs*alpha-1)^2 * (Nobs*alpha-2));
        theoreticalVarMin_(NobsIter,NmcIter) = (Nobs*alpha*beta^2) /(Nobs*alpha-2);
    end % NmcIter
    
    xhatBlue = mean(xhatBlue_);
    xhatMvuKnown = mean(xhatMvuKnown_);
%     xhatMvuUnknown = mean(xhatMvuUnknown_);
    xhatMin = mean(xhatMin_);
    biasBlue = xhatBlue - x0;
    biasMvuKnown = xhatMvuKnown - x0;
%     biasMvuUnknown = xhatMvuUnknown - x0;
    biasMin = xhatMin - x0;
    varBlue =  sum((xhatBlue_ - xhatBlue).^2)/Nmc;
    varMvuKnown =  sum((xhatMvuKnown_ - xhatMvuKnown).^2)/Nmc;
%     varMvuUnknown =  sum((xhatMvuUnknown_ - xhatMvuUnknown).^2)/Nmc;
    varMin =  sum((xhatMin_ - xhatMin).^2)/Nmc;
    
    mseBlue(NobsIter) = varBlue + biasBlue^2;
    mseMvuKnown(NobsIter) = varMvuKnown + biasMvuKnown^2;
%     mseMvuUnknown(NobsIter) = varMvuUnknown + biasMvuUnknown^2;
    mseMin(NobsIter) = varMin + biasMin^2;
    
    % theoretical variance for each sample size
    theoreticalVarBlue(NobsIter) = mean(theoreticalVarBlue_(NobsIter,:));
    theoreticalVarMvuKnown(NobsIter) = mean(theoreticalVarMvuKnown_(NobsIter,:));
    theoreticalVarMin(NobsIter) = mean(theoreticalVarMin_(NobsIter,:));
end % NobsIter

figpareto = plotLines(NobsVec,'pareto', ...
    mseBlue,mseMvuKnown,[],mseMin, ...
    theoreticalVarBlue, theoreticalVarMvuKnown, ...
    [], theoreticalVarMin);



if ifSave
    figName = 'estimationMse_pareto';
    saveas(figpareto,['../report_arxiv/fig/' figName '.fig'])
    saveas(figpareto,['../report_arxiv/fig/' figName '.eps'],'epsc')
end