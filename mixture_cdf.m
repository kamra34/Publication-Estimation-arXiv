clear all; close all;

%% This code corresponds to the comparison of different errors used in the
% evaluations
nMc = 100;
errMix1 = [];errMix2 = [];errMix3 = [];
rng('default')
alpha1 = 0.01; % mixture components
alpha2 = 0.5; % mixture components
alpha3 = 0.99; % mixture components
for i =1:nMc
    std = unifrnd(1,9,1,1); %Normal std
    b = unifrnd(1,50,1,1); % Uniform maximum support
    U1 = rand(2000,1)<=alpha1; % U is true with probability p and false with probability 1-p
    e1 = (1-U1).*unifrnd(0,b,2000,1)+U1.*normrnd(0,std,2000,1);
    errMix1 = [errMix1;e1];
    
    U2 = rand(2000,1)<=alpha2; % U is true with probability p and false with probability 1-p
    e2 = (1-U2).*unifrnd(0,b,2000,1)+U2.*normrnd(0,std,2000,1);
    errMix2 = [errMix2;e2];
    
    U3 = rand(2000,1)<=alpha3; % U is true with probability p and false with probability 1-p
    e3 = (1-U3).*unifrnd(0,b,2000,1)+U3.*normrnd(0,std,2000,1);
    errMix3 = [errMix3;e3];
end

[val1,prob1] = plotposErrCdf(errMix1);
[val2,prob2] = plotposErrCdf(errMix2);
[val3,prob3] = plotposErrCdf(errMix3);

figure();plotfix(); hold all;
h1 = plot(val1,prob1,'LineWidth',2,'Color',[0.31,0.4,0.58]);
h2 = plot(val2,prob2,'LineWidth',2,'Color',[0.16,0.38,0.27]);
h3 = plot(val3,prob3,'LineWidth',2,'Color',[0.64,0.08,0.18]);
grid on
box on
LEG = legend([h1,h2,h3],{'$a=0.01$','$a=0.5$','$a=0.99$'},'Interpreter','latex','Location','southeast');
LEG.FontSize = 16;
ylabel('CDF','FontWeight','bold'); xlabel('Measurement Error', 'FontWeight', 'bold');
% xlim([0,60])