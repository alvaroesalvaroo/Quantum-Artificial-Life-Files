alpha = 1;
beta = 1.5;
delta = 2;
gamma = 1;
%f=0.5; % afects period (only?¿) 
%alpha=alpha*f; delta=delta*f; beta=beta*f; gamma=gamma*f;
x0=1.5;y0=1;
poseq=[gamma/delta, alpha/beta]
% alpha=0;gamma=0;
% yp(1) = alpha*y(1) -beta*y(2)*y(1);
% yp(2) = -gamma*y(2)+delta*y(1)*y(2);

yp= @(t,y)[alpha*y(1)-beta*y(2)*y(1); -gamma*y(2)+delta*y(1)*y(2)];

%subplot(2,1,2)
opts = odeset('Refine',20,'RelTol',1e-8);
[t,y] = ode45(yp,[0 15],[x0,y0],opts);
%subplot(1,2,1)
plot(t,y(:,1),'b','LineWidth',2);grid on;
xlabel('time');ylabel('individuals')
hold on;
plot(t,y(:,2),'r','LineWidth',2);
%legend('preys','predators')
%subplot(1,2,2)
%plot(y(:,1),y(:,2),'b','Linewidth',2);grid on
%xlabel('preys');ylabel('predators')
legend('x (preys)','y(predators)')
grid on
hold off

