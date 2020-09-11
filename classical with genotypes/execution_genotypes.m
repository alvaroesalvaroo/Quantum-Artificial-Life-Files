%% Initialization of simulation.
% Needed functions: noquantumsim.m, plotlattice.m, fillfield.m, checkfree.m
% here we choose the variables which define our simulation

% version 2.0: probability for predators is proportional to preys
clear;clc;

% Death value for sigmaz:
deathvalue=-0.8;

% grid dimensions.
L1=60; L2=60;

% number of steps of simulation
maxstep=600;

% PROBABILITY OF SELF-REPLICATING = 1/prob parameter
probprey=0.15;
probpredator=0.0008; % NOW THIS PROB IS MUCH SMALLER SINCE WE WILL MULTIPLICATE IT FOR THE
% NUMBER OF PREYS

% Number of initials individuals
initialpreys=150;
initialpredators=270;
%initialpreys=800;
%initialpredators=800;

% Maximal number of individuals. In order to remove bounds, try some huge
% number (10^9, for instance)
maxpreys=2500;
maxpredators=2500;

% angle used for the time-passing channel (in case we use a quantum channel)
t_ang=0.5;

% to avoid time passing:
gammat=sin(t_ang/2)^2; % time-amplitude damping parameter!
% angle in radians, associated with amplitude damping at feeding interactions
f_ang=2;
gammaf=sin(f_ang/2)^2;
% gammaf needs to be greater that gammat so that feeding interactions are stroger than time passing and model makes sense

% angles that defines preys and predators. With these values, initially, sz~0.71 for preys and sz~-0.71 for predators
anglepredator=pi/4;
angleprey=3*pi/4;

% do we want to show plots? do we want to save plots? When we're are
% permorming large computations we can save the time we use generating
% plots
showplot=false;
saveplot=false; % only works if showplots? is true
pausetime=0; % time in seconds that programme stops so that we can observe the lattice. Give it 0 value unless lattice is really small

%% Here we execute several simulations using all these parameters and save results
Nsimulations=50; % if we are not trying to average many simulations, choose Nsimulations=1
% for observing genotypes evolution, usually we have to average several
% simulations
datapreys=zeros(Nsimulations,maxstep+1);
datapredators=zeros(Nsimulations,maxstep+1);
interactions=zeros(Nsimulations,maxstep+1);
for n=1:Nsimulations
    [a, b, c, d]=noquantumsim4(deathvalue,L1,L2,maxstep,probprey,probpredator,initialpreys,initialpredators,maxpreys,maxpredators,gammat,gammaf,anglepredator,angleprey,showplot,saveplot,n,Nsimulations);
    if length(a)==maxstep+1
        datapreys(n,:)=a;
        datapredators(n,:)=b;
    end
    if length(c)==maxstep
        predatorgen(n,:)=c;
        preygen(n,:)=d;
    end
end
%% clear unuseful data (wrong simulations)
size(preygen);
N=ans(1);
for k=1:N
    if preygen(N-k+1,1)==0
        datapreys(N-k+1,:)=[];
        preygen(N-k+1,:)=[];
        predatorgen(N-k+1,:)=[];
        datapredators(N-k+1,:)=[];
    end
end
%% Plotting evolution of individuals. Averaging if necessary
hold off
sgt=sgtitle(['P_{born}=',num2str(probprey),'(preys), ',num2str(probpredator), '(predators); ',' \gamma_t=',num2str(gammat),'\gamma_f=',num2str(gammaf),'; Preys_0=',num2str(initialpreys),',Preds_0=',num2str(initialpredators)]);
%ax = gca; ax.TitleFontSizeMultiplier = 1;
sgt.FontSize = 10;

% subplot(2,1,1);

% plot(1:(maxstep+1), mean(datapredators,1),'r-');
% hold on
% xlabel('steps');
% grid minor
% plot(1:(maxstep+1), mean(datapreys,1),'b-');
% legend('predators','preys');
% hold off

plot(1:(maxstep), mean(preygen,1),'b-')
hold on; grid on
plot(1:(maxstep), mean(predatorgen,1),'r-');
legend('predators','preys');
title('mean genotype value')



% subplot(1,2,2);
% plot(mean(datapreys,1),mean(datapredators,1),'b.-');
% xlabel('preys'); ylabel('predators');
% grid minor;
% hold off

