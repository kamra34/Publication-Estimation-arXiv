clear all; close all;

%% This code corresponds to the comparison of different errors used in the 
% evaluations
nMc = 1000;
errUnif = [];errExp = [];errRay= [];errPar = [];errWei = [];errMix = [];

rng('default')
for i =1:nMc
    b = unifrnd(6,50,1,1); % maximum support of uniform
    eUnif = unifrnd(0,b,2000,1);
    errUnif = [errUnif;eUnif];
end

rng('default')
for i =1:nMc
    beta = unifrnd(5,14,1,1); % maximum support of uniform
    eExp = exprnd(beta,2000,1);
    errExp = [errExp;eExp];
end

rng('default')
for i =1:nMc
    beta = unifrnd(5,12,1,1); % maximum support of uniform
    eRay = raylrnd(beta,2000,1);
    errRay = [errRay;eRay];
end

rng('default')
for i =1:nMc
    beta = 6;%unifrnd(0.01,0.05,1,1); % maximum support of uniform
    alpha =unifrnd(2.1,2.5,1,1);
    ePar = randp(2000,1,alpha,beta);
    errPar = [errPar;ePar];
end

rng('default')
for i =1:nMc
    beta = 1; % maximum support of uniform
    alpha = unifrnd(5,10,1,1);
    eWei = wblrnd(alpha,beta,2000,1);
    errWei = [errWei;eWei];
end

[valUnif,probUnif] = plotposErrCdf(errUnif);
[valExp,probExp] = plotposErrCdf(errExp);
[valRay,probRay] = plotposErrCdf(errRay);
[valPar,probPar] = plotposErrCdf(errPar);
[valWei,probWei] = plotposErrCdf(errWei);


figure();plotfix(); hold all;
h1 = plot(valUnif,probUnif,'LineWidth',2,'Color','black');
h2 = plot(valExp,probExp,'--','LineWidth',2,'Color','black');
h3 = plot(valRay,probRay,'-.','LineWidth',2,'Color','black');
h4 = plot(valPar,probPar,'-','LineWidth',2,'Color','blue');
h5 = plot(valWei,probWei,'--','LineWidth',2,'Color','blue');
grid on
box on
legend([h1,h2,h3,h4,h5],'Uniform','Exponential','Rayleigh','Pareto','Weibull')
ylabel('CDF','FontWeight','bold'); xlabel('Measurement Error', 'FontWeight', 'bold');
xlim([0,60])
