function [ p ] = plotFun(t,y,xl,yl,tA,tB,tD,tI,tP,tS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P=figure
    subplot(3,2,1)
        plot(t,y(:,1),'b--')
        ylabel(xl)
        xlabel(yl)
        title(tA,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid
   subplot(3,2,2)
        plot(t,y(:,2),'b--')
        ylabel(xl)
        xlabel(yl)
        title(tB,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid
   subplot(3,2,3)
        plot(t,y(:,3),'b--')
        ylabel(yl)
        xlabel(xl)
        title(tD,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid
   subplot(3,2,4)
        plot(t,y(:,4),'b--')
        ylabel(yl)
        xlabel(xl)
        title(tI,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid
   subplot(3,2,5)
        plot(t,y(:,5),'b--')
        ylabel(yl)
        xlabel(xl)
        title(tP,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid
   subplot(3,2,6)
        plot(t,y(:,6),'b--')
        ylabel(yl)
        xlabel(xl)
        title(tS,'FontSize',16);
        set(gca,'LineWidth',1,'FontSize',12,'FontWeight','bold')
        grid

end

