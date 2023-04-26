function [fig] = plotLines2(NobsVec,errDist, ...
    mseBlue,mseMvuKnown,mseMvuUnknown,mseMin, ...
    theoreticalVarBlue_, theoreticalVarMvuKnown_, ...
    theoreticalVarMvuUnknown_, theoreticalVarMin_)

tVec = NobsVec;
bpCol = [0.2,0.4,0.7333 ; 0.2,0.6,0.2 ; 0.5,0.5,0.5 ; 0.8,0.2,0.2];

if strcmp(errDist,'mixture')
    fig = figure;
    set(gcf, 'unit', 'inches');
    fig.Name = strvcat(['fig_',data.sim.errDist]);
    plotfix()
    axes1 = axes('Parent',fig);
    hold(axes1,'on');
    plot(tVec, data.sim.mseBlue,'x','Color',[0.45,0.69,0.95])
    h1 = plot(tVec, data.sim.theoreticalVarBlue_(:,1),'-','Color',bpCol(1,:));
    
    plot(tVec, data.sim.mseMle,'x','Color',[0.55,0.92,0.64])

    set(axes1,'YMinorTick','on','YScale','log');
    set(axes1,'XMinorTick','on');
    box on
    grid on
    xlabel('epoch','FontSize',16)
    ylabel('MSE($\hat{x}_t$)','FontSize',16,'Interpreter','Latex')
    xlim([-3 203])
    ylim([1.5 100])
    yticks([1.5 10 100])
    yticklabels({1,10,100})
    figure_size = get(gcf,'Position');
else
    mSize = 6;
    fig = figure;
    set(gcf, 'unit', 'inches');
    fig.Name = strvcat(['fig_',errDist]);
    plotfix()
    axes1 = axes('Parent',fig);
    hold(axes1,'on');
    h11 = plot(tVec, mseBlue,'x','MarkerSize',mSize,'Color',[0.45,0.69,0.95]);
    
    
    h22 = plot(tVec, mseMvuKnown,'x','MarkerSize',mSize,'Color',[0.55,0.92,0.64]);
    
    
        if any(mseMvuUnknown)
    h33 = plot(tVec, mseMvuUnknown,'x','MarkerSize',mSize,'Color',[0.7,0.7,0.7]);
    end
    
    
    h44 = plot(tVec, mseMin,'x','MarkerSize',mSize,'Color',[0.83,0.57,0.57]);
    
    h1 = plot(tVec, theoreticalVarBlue_,'-','LineWidth',3,'Color',bpCol(1,:));
    h2 = plot(tVec, theoreticalVarMvuKnown_,'-','LineWidth',3,'Color',bpCol(2,:));
        if any(theoreticalVarMvuUnknown_)
    h3 = plot(tVec, theoreticalVarMvuUnknown_,'-','LineWidth',3,'Color',bpCol(3,:));
    end
    h4 = plot(tVec, theoreticalVarMin_,'-','LineWidth',3,'Color',bpCol(4,:));
    figure_size = get(gcf,'Position');
    set(axes1,'YMinorTick','on','YScale','log');
    set(axes1,'XMinorTick','on');
    box on
    grid on
    xlabel('sample size N','FontSize',16)
    ylabel('MSE($\hat{x}_N$)','FontSize',16,'Interpreter','Latex')
    xlim([1.5 20])
    ylim([0.01 1000])
%     yticks([1.5 10 100])
%     yticklabels({1,10,100})
    
    if strcmp(errDist,'uniform')
        LEG = legend([h1,h2,h3,h4],{'BLUE, known hyperparameter','proposed estimator, known hyperparameter','proposed estimator, unknown hyperparameter', 'minimum order statistics estimator'},'Location','northoutside');
        LEG.FontSize = 16;
        set(LEG, 'unit', 'inches')
        legend_size = get(LEG, 'position');
        figure_size(4) = figure_size(4) + legend_size(4) + 0.3;
        set(gcf, 'Position', figure_size)
        legend boxoff
    end

end

end