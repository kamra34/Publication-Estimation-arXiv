clear all; close all;


fontSize = 16;
LW = 4;
x = -40:0.0001:60;
mean = 0;
std = 8;
b = 60;
pdUnifMix = makedist('Uniform','Lower',0,'Upper',b);
pdNormalMix = makedist('Normal','mu',mean,'sigma',std);

% alpha = 0.01
alpha = 0.01;
U_01 = rand(1,50000)<=alpha; % U is true with probability p and false with probability 1-p
R_01 = U_01.*normrnd(mean,std,1,50000)+(1-U_01).*unifrnd(0,b,1,50000);
yUnifMix_01 = pdf(pdUnifMix,x); yNormalMix_01 = pdf(pdNormalMix,x);
yMix_01 = alpha*yNormalMix_01 + (1-alpha)*yUnifMix_01;

% alpha = 0.99
alpha = 0.99;
U_99 = rand(1,50000)<=alpha; % U is true with probability p and false with probability 1-p
R_99 = U_99.*normrnd(mean,std,1,50000)+(1-U_99).*unifrnd(0,b,1,50000);
yUnifMix_99 = pdf(pdUnifMix,x); yNormalMix_99 = pdf(pdNormalMix,x);
yMix_99 = alpha*yNormalMix_99 + (1-alpha)*yUnifMix_99;

% alpha = 0.5
alpha = 0.5;
U_5 = rand(1,50000)<=alpha; % U is true with probability p and false with probability 1-p
R_5 = U_5.*normrnd(mean,std,1,50000)+(1-U_5).*unifrnd(0,b,1,50000);
yUnifMix_5 = pdf(pdUnifMix,x); yNormalMix_5 = pdf(pdNormalMix,x);
yMix_5 = alpha*yNormalMix_5 + (1-alpha)*yUnifMix_5;



fNoise = figure();set(gcf, 'unit', 'inches');
hold all
histogram(R_01,35,'Normalization','pdf','FaceColor',[0.87,0.97,0.88],'EdgeColor',[0.39,0.83,0.07])
histogram(R_99,35,'Normalization','pdf','FaceColor',[0.71,0.75,0.98],'EdgeColor',[0,0,1])
histogram(R_5,35,'Normalization','pdf','FaceColor',[0.98,0.57,0.65],'EdgeColor',[1.00,0.00,0.00])
h1 = plot(x,yMix_01,'LineWidth',LW,'Color',[0.39,0.83,0.07]);
h2 = plot(x,yMix_99,'LineWidth',LW,'Color',[0,0,1]);
h3 = plot(x,yMix_5,'LineWidth',LW,'Color',[1,0,0]);
figure_size = get(gcf,'Position');
xlabel('$e_k$','Interpreter','Latex'); ylabel('p(e$_k$)','Interpreter','Latex');
ax = gca;ax.FontSize = fontSize;
xlim([-30,65])
ylim([-0.0007 0.08])
x_label = 'measurement noise [m]';
y_label = 'density';
box on
LEG = legend([h1,h2,h3],'$\alpha=0.01$','$\alpha = 0.99$','$\alpha=0.5$','Interpreter','Latex','Location','northoutside');
LEG.FontSize = fontSize;
set(LEG, 'unit', 'inches')
legend_size = get(LEG, 'position');
figure_size(4) = figure_size(4) + legend_size(4) + 0.3;
set(gcf, 'Position', figure_size)
legend boxoff



[val1,prob1] = plotposErrCdf(R_01);
[val2,prob2] = plotposErrCdf(R_99);
[val3,prob3] = plotposErrCdf(R_5);

figure();plotfix(); hold all;
h1 = plot(val1,prob1,'LineWidth',LW,'Color',[0.39,0.83,0.07]);
h2 = plot(val2,prob2,'LineWidth',LW,'Color',[0,0,1]);
h3 = plot(val3,prob3,'LineWidth',LW,'Color',[1,0,0]);
grid on
box on
% LEG = legend([h1,h2,h3],{'$a=0.01$','$a=0.99$','$a=0.5$'},'Interpreter','latex','Location','southeast');
% LEG.FontSize = 16;
ylabel('CDF'); 
xlabel('$e_k$','Interpreter','Latex'); 

xlim([-30,65])

