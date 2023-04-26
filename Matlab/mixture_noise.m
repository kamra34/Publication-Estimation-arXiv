clear all; close all
% This code corresponds to the comparison of BLUe and order statistics


% -------------- Simulation parameters ----------------
Nmc = 100; % number of MC run
NobsVec = 2:5:2000; % data sample size
alpha1 = 0.01; % mixture components
alpha2 = 0.99; % mixture components
alpha3 = 0.5; % mixture components
ifSave = 0;

% -------------- Define estimators ----------------
% Blue estimator
blueEstimator = @(N,y,b,alpha) ((1/N)*sum(y) - (b*(1-alpha)/2));
% proposed estimator
estimator = @(Na,ys) ys(Na);

for NobsIter=1:length(NobsVec) % loop for samples of varying sizes
    %     rng('default')
    Nobs = NobsVec(NobsIter);
    Na1 = floor(Nobs*alpha1/2)+1;
    Na2 = floor(Nobs*alpha2/2)+1;
    Na3 = floor(Nobs*alpha3/2)+1;
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        % randomly generate b and x
        std = 4; %Normal std
        b = 60; % Uniform maximum support
        x0 = 10; % true parameter value
        U1 = rand(Nobs,1)<=alpha1; % U is true with probability p and false with probability 1-p
        U2 = rand(Nobs,1)<=alpha2; % U is true with probability p and false with probability 1-p
        U3 = rand(Nobs,1)<=alpha3; % U is true with probability p and false with probability 1-p
        
        e1 = (1-U1).*unifrnd(0,b,Nobs,1)+U1.*normrnd(0,std,Nobs,1);
        y1 = x0 + e1; % generate the measurement vector
        
        e2 = (1-U2).*unifrnd(0,b,Nobs,1)+U2.*normrnd(0,std,Nobs,1);
        y2 = x0 + e2; % generate the measurement vector
        
        e3 = (1-U3).*unifrnd(0,b,Nobs,1)+U3.*normrnd(0,std,Nobs,1);
        y3 = x0 + e3; % generate the measurement vector
        
        % all estimators
        xhatBlue1_(NmcIter) = blueEstimator(Nobs,y1,b,alpha1);
        xhatBlue2_(NmcIter) = blueEstimator(Nobs,y2,b,alpha2);
        xhatBlue3_(NmcIter) = blueEstimator(Nobs,y3,b,alpha3);
        
        xhat1_(NmcIter) = estimator(Na1,sort(y1));
        xhat2_(NmcIter) = estimator(Na2,sort(y2));
        xhat3_(NmcIter) = estimator(Na3,sort(y3));
        
        theoreticalVarBlue1_(NobsIter,NmcIter) = ((b^2*(1+((2-3*alpha1)*alpha1))) + 12*alpha1*std^2) / (12*Nobs);
        theoreticalVarBlue2_(NobsIter,NmcIter) = ((b^2*(1+((2-3*alpha2)*alpha2))) + 12*alpha2*std^2) / (12*Nobs);
        theoreticalVarBlue3_(NobsIter,NmcIter) = ((b^2*(1+((2-3*alpha3)*alpha3))) + 12*alpha3*std^2) / (12*Nobs);
    end % NmcIter
    
    xhatBlue1 = mean(xhatBlue1_);
    xhat1 = mean(xhat1_);
    biasBlue1 = xhatBlue1 - x0;
    biasXhat1 = xhat1 - x0;
    varBlue1 =  sum((xhatBlue1_ - xhatBlue1).^2)/Nmc;
    varXhat1 =  sum((xhat1_ - xhat1).^2)/Nmc;
    mseBlue1(NobsIter) = varBlue1 + biasBlue1^2;
    mseXhat1(NobsIter) = varXhat1 + biasXhat1^2;
    theoreticalVarBlue1(NobsIter) = mean(theoreticalVarBlue1_(NobsIter,:));
    
    xhatBlue2 = mean(xhatBlue2_);
    xhat2 = mean(xhat2_);
    biasBlue2 = xhatBlue2 - x0;
    biasXhat2 = xhat2 - x0;
    varBlue2 =  sum((xhatBlue2_ - xhatBlue2).^2)/Nmc;
    varXhat2 =  sum((xhat2_ - xhat2).^2)/Nmc;
    mseBlue2(NobsIter) = varBlue2 + biasBlue2^2;
    mseXhat2(NobsIter) = varXhat2 + biasXhat2^2;
    theoreticalVarBlue2(NobsIter) = mean(theoreticalVarBlue2_(NobsIter,:));
    
    xhatBlue3 = mean(xhatBlue3_);
    xhat3 = mean(xhat3_);
    biasBlue3 = xhatBlue3 - x0;
    biasXhat3 = xhat3 - x0;
    varBlue3 =  sum((xhatBlue3_ - xhatBlue3).^2)/Nmc;
    varXhat3 =  sum((xhat3_ - xhat3).^2)/Nmc;
    mseBlue3(NobsIter) = varBlue3 + biasBlue3^2;
    mseXhat3(NobsIter) = varXhat3 + biasXhat3^2;
    theoreticalVarBlue3(NobsIter) = mean(theoreticalVarBlue3_(NobsIter,:));

end % NobsIter

fig1 = plotLines(NobsVec,'mixture1', ...
    mseBlue1,mseXhat1,[],[], ...
    theoreticalVarBlue1, [], ...
    [], []);


fig2 = plotLines(NobsVec,'mixture2', ...
    mseBlue2,mseXhat2,[],[], ...
    theoreticalVarBlue2, [], ...
    [], []);

fig3 = plotLines(NobsVec,'mixture3', ...
    mseBlue3,mseXhat3,[],[], ...
    theoreticalVarBlue3, [], ...
    [], []);



if ifSave
    figName = 'estimationMse_mixture01';
    saveas(fig1,['../report_arxiv/fig/' figName '.fig'])
    saveas(fig1,['../report_arxiv/fig/' figName '.eps'],'epsc')
    figName = 'estimationMse_mixture99';
    saveas(fig2,['../report_arxiv/fig/' figName '.fig'])
    saveas(fig2,['../report_arxiv/fig/' figName '.eps'],'epsc')
    figName = 'estimationMse_mixture5';
    saveas(fig3,['../report_arxiv/fig/' figName '.fig'])
    saveas(fig3,['../report_arxiv/fig/' figName '.eps'],'epsc')
end








