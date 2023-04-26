clear all; close all;

%% This code compares different order statistic variances for the case with
%uniform noise with support from 0 to b>0.

% -------------- Simulation parameters ----------------
x0 = 5; % true parameter value
b = 10; % maximum support of uniform
Nmc = 50; % number of MC run
Nobs = 1001; % data sample size
k=1:10:Nobs; % order of the data

% -------------- Define order estimator ----------------
Estimator = @(N,ys,b,k) (ys(k) - (k*b/(N+1)));

for kIter=1:length(k) % loop for different order statistics
    
    Kobs = k(kIter); % which order statistic
    
    for NmcIter = 1:Nmc % Nmc monte carlo runs for each sample size
        
        e = unifrnd(0,b,Nobs,1); % generate the noise
        y = x0 + e; % generate the measurement vector
        
        ys = sort(y); % sort the data
        xhat_ = Estimator(Nobs,ys,b,Kobs); % estimate
        
        var_(NmcIter) = (xhat_-x0)^2; %simulation variance in each iteration
    end %NmcIter
    
    % simulation variance after Nmc iterations for each sample size
    var(kIter) = mean(var_);
    % theoretical variance for each order statistic
    theoreticalVar(kIter) = Kobs*(Nobs-Kobs+1)*b^2 / ((Nobs+1)^2 * (Nobs+2));
end % NobsIter


figure()
hold all; plotfix()
h1 = plot(k,var,'rx');
h2 = plot(k,theoreticalVar,'b-');
LEG = legend([h1,h2],'simulation','theoretical');
LEG.FontSize = 16;
box on
grid on
xlim([k(1) k(end)])
xlabel('k','FontSize',16)
ylabel('MSE','FontSize',16)