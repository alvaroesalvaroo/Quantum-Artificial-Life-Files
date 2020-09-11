%% Initialization of simulation.
% Needed functions: noquantumsim.m, plotlattice.m, fillfield.m, checkfree.m
% here we choose the variables which define our simulation

% in this version probability for predators is proportional to preys
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


% Maximal number of individuals. In order to remove bounds, try some huge
% number (10^9, for instance)
maxpreys=10000000;
maxpredators=10000000;

% angle used for the time-passing channel (in case we use a quantum channel)
t_ang=0.4924;

% to avoid time passing:
eta_t=sin(t_ang/2)^2; % time-amplitude damping parameter!
gammat=-log(1-eta_t); % correction applied, since we will use gamma parameter

% angle in radians, associated with amplitude damping at feeding interactions
f_ang=1.5856;
eta_f=sin(f_ang/2)^2;
gammaf=-log(1-eta_f);
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
Nsimulations=1; % if we are not trying to average many simulations, choose Nsimulations=1

datapreys=zeros(Nsimulations,maxstep+1);
datapredators=zeros(Nsimulations,maxstep+1);
interactions=zeros(Nsimulations,maxstep+1);
for n=1:Nsimulations
    [datapreys(n,:),datapredators(n,:)]=noquantumsim3(deathvalue,L1,L2,maxstep,probprey,probpredator,initialpreys,initialpredators,maxpreys,maxpredators,gammat,gammaf,anglepredator,angleprey,showplot,saveplot,n,Nsimulations);
end
%% Plotting evolution of individuals. Averaging if necessary
hold off
sgt=sgtitle(['P_{born}=',num2str(probprey),'(preys), ',num2str(probpredator), '(predators); ',' \gamma_t=',num2str(gammat),'\gamma_f=',num2str(gammaf),'; Preys_0=',num2str(initialpreys),',Preds_0=',num2str(initialpredators)]);
%ax = gca; ax.TitleFontSizeMultiplier = 1;
sgt.FontSize = 10;

% subplot(2,1,1);
plot(1:(maxstep+1), mean(datapredators,1),'r-');
hold on
xlabel('steps');
grid minor
plot(1:(maxstep+1), mean(datapreys,1),'b-');
legend('predators','preys');
hold off

% subplot(1,2,2);
% plot(mean(datapreys,1),mean(datapredators,1),'b.-');
% xlabel('preys'); ylabel('predators');
% grid minor;
% hold off
