
function [alivepreys,alivepredators]=noquantumsim3(deathvalue,L1,L2,maxstep,probprey,probpredator,initialpreys,initialpredators,maxpreys,maxpredators,gammat,gammaf,anglepredator,angleprey,showplot,saveplot,n,Nsim)
% functions which increase or decrease sz in the way we want
increasefeed=@(sz) -(((-sz+1)/2)*exp(-gammaf)*2-1);
decreasefeed=@(sz) ((sz+1)/2)*exp(-gammaf)*2-1;
decreasetime=@(sz) ((sz+1)/2)*exp(-gammat)*2-1;

field=zeros(L1,L2); % matrix which represent the lattice. 0 = void cell

% sz (life) value of individuals
szpreys=ones(1,initialpreys)*(sin(angleprey/2)^2-cos(angleprey/2)^2);
szpredators=ones(1,initialpredators)*(sin(anglepredator/2)^2-cos(anglepredator/2)^2);

% matrices with individuals position in the grid
preyspos=zeros(initialpreys,2);
predatorspos=zeros(initialpredators,2);

% assign random position for preys
for j=1:initialpreys
    isfree=false;
    while isfree==false
        pos = [floor(rand*L1+1), floor(rand*L2+1)];
        % random position in the grid
        isfree=checkfree(pos, field);
        if isfree
            field(pos(1),pos(2))=1+szpreys(j)/2;
            preyspos(j,1)=pos(1);
            preyspos(j,2)=pos(2);
        end
    end
end

% assign random position for predators
for j=1:initialpredators
    isfree=false;
    while isfree==false
        pos = [floor(rand*L1+1), floor(rand*L2+1)];
        %random position in the grid
        isfree=checkfree(pos,field);
        if isfree
            field(pos(1),pos(2))=2+szpredators(j)/2;
            predatorspos(j,1)=pos(1);
            predatorspos(j,2)=pos(2);
        end
    end
end

% plot things

w = waitbar(0,'Initializing...');
if showplot
    
    if saveplot
        close
        h=figure;
    else
        hold off
    end
    plotlattice(field)
    if saveplot
        axis tight manual
        drawnow
        filename = 'noquantum.gif';
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        % imwrite(imind,cm,filename,'gif','WriteMode','append'); % this one for
        % later
    end
end
% vectors reporting at each step all 
alivepreys=zeros(1,maxstep+1);
alivepredators=zeros(1,maxstep+1);
alivepreys(1)=initialpreys; alivepredators(1)=initialpredators;


for step=1:maxstep

    % do things:
    % First interact. Then pass time. Then checkdeaths. Then newborns. Plot result. Then move again
    % individuals
    size(preyspos);
    npreys=ans(1);
    size(predatorspos);
    npredators=ans(1);
    
    % check if there are interactions, and simulate interactions
    for k=1:npreys
        for j=1:npredators
            if (norm(preyspos(k,:)-predatorspos(j,:))<1.5) && (preyspos(k,1)~=0) && (predatorspos(j,1)~=0)
                % this condition ensures that both individuals are at
                % continous cells, since the norm of their difference
                % vector is sqrt(2) or less
                % We also heck that individuals are not at cementery
                % szpredators(j)=increasefeed(szpredators(j));
               % VERSION 3 DELETES INCREASING OF FEED BY PREDATORS
                szpreys(k)=decreasefeed(szpreys(k));
                
            end
        end
    end
    
    % pass time (for preys)
    for k=1:npreys
        szpreys(k)=decreasetime(szpreys(k));
    end
    
    % pass time (for predators)
    for k=1:npredators
        szpredators(k)=decreasetime(szpredators(k));
    end
    
    % checkdeaths (for preys)
    aux=npreys;
    for k=1:npreys
        if k<npreys
            if szpreys(npreys+1-k)<deathvalue
                szpreys(npreys+1-k)=[];
                % remove individual
                field(preyspos(npreys+1-k,1),preyspos(npreys+1-k,2))=0;
                preyspos(npreys+1-k,:)=[];
                aux=aux-1;
            end
        else
            if aux>1 && szpreys(1)<deathvalue % the last individual will be killed only if we have another alive individual
                szpreys(1)=[];
                field(preyspos(1,1),preyspos(1,2))=0;
                preyspos(1,:)=[];
                aux=aux-1;
            end
        end     
    end
    npreys=aux;
    
    % checkdeaths (for predators)
    aux=npredators;
    for k=1:npredators
        if k<npredators
            if szpredators(npredators+1-k)<deathvalue 
                szpredators(npredators+1-k)=[];
                % remove individual
                field(predatorspos(npredators+1-k,1),predatorspos(npredators+1-k,2))=0;
                predatorspos(npredators+1-k,:)=[];
                aux=aux-1;
            end
        else
            if aux>1 && szpredators(1)<deathvalue
                % the last individual will be killed only if we have another alive individual

                szpredators(1)=[];
                aux=aux-1;
                field(predatorspos(1,1),predatorspos(1,2))=0;
                predatorspos(1,:)=[];

            end
        
        end
    end
    npredators=aux;
    
   
    
    % newborns preys
    for k=1:npreys
        % with a certain prob, and only if number of preys is not maximal
        if (rand<probprey) && (npreys<maxpreys)
            % NEWBORN!
            npreys=npreys+1;
            
            % give sz value its correspondent value
            szpreys(npreys)=(sin(angleprey/2)^2-cos(angleprey/2)^2);
            % asign a free random position to new born
            isfree=false;
            %looper=0; % I used this variable to debug
            while isfree==false
                pos = [floor(rand*L1+1), floor(rand*L2+1)];
                %random position in the grid
                isfree=checkfree(pos, field);
                if isfree
                    field(pos(1),pos(2))=1+szpreys(npreys)/2;
                    preyspos(npreys,1)=pos(1);
                    preyspos(npreys,2)=pos(2);
                    % disp(['new prey at position ', num2str(pos(1)),num2str(pos(2))])
                end
                %looper=loper+1;
                
            end
            % disp(looper)
        end
    end
    
    % newborn predators
    for k=1:npredators
        if (rand<probpredator*npreys) && (npredators<maxpredators)
            % NEWBORN!
           
            npredators=npredators+1;
            
            % give sz value its correspondent value
            szpredators(npredators)=(sin(anglepredator/2)^2-cos(anglepredator/2)^2);
            % asign a free random position to new born
            isfree=false;
            count=0;
            while isfree==false
                pos = [floor(rand*L1+1), floor(rand*L2+1)];
                %random position in the grid
                isfree=checkfree(pos, field);
                if isfree
                    field(pos(1),pos(2))=1+szpredators(npredators)/2;
                    predatorspos(npredators,1)=pos(1);
                    predatorspos(npredators,2)=pos(2);
                    % disp(['new predator at position ', num2str(pos(1)),num2str(pos(2))])
                end
                count=count+1;
                if count==10*L1*L2
                    % this means there was no way to find place for this
                    % buddy
                    npredators=npredators-1;
                    break
                end
            end
        end
    end
    
    field=fillfield2(L1,L2,preyspos,predatorspos,szpredators,szpreys,deathvalue);
    %alivepredators(step+1)=sum(szpredators>deathvalue);
    %alivepreys(step+1)=sum(szpreys>deathvalue);
    alivepreys(step+1)=npreys;
    alivepredators(step+1)=npredators;
    
    if alivepredators(step+1)==0 && alivepreys(step+1)==0
        % close(w);
        disp(['Simulation ',num2str(n),' aborted. Everyone is died. Step = ',num2str(step)])        
        break
    end
    % here we make the plot

    waitbar((n-1+step/maxstep)/Nsim,w,['progress: step ',num2str(step),' out of ',num2str(maxstep),'. Simulation ',num2str(n),' out of ',num2str(Nsim)]);
    for k=1:1 % this stupid loop only allows us to hide the plotting code
        if showplot
            hold off
            plotlattice(field)
            if saveplot
                axis tight manual
                drawnow
                frame = getframe(h); 
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256); 
                % Write to the GIF File 
                imwrite(imind,cm,filename,'gif','WriteMode','append'); % this one for
            end
        end
    end 
    % to avoid lattice overpopulation, let us stop when lattice is 90% full
    occupation=(npreys+npredators)/(L1*L2);
    if occupation>0.8
        disp('Lattice is more than 80 % full')
    end
    if occupation>0.9
        % close(w);
        disp('Lattice is more than 90 % full. Abort simulation')
        break
    end

    % Moving preys
    for k=1:npreys
        pos=preyspos(k,:); % position of the individual
        if pos(1)~=0  % only if individual is not at the cementery we move it
            
            % p is random number between 1-9
            p=floor(rand*9)+1;
            % each number represent a movement according to:
            %     1 2 3
            %     4 5 6
            %     7 8 9
            % where the individual is in the 5 cell
            % if grid ends 

            if p==1 % up and left
               newpos=pos+[-1,1];    
            elseif p==2 % up
                newpos=pos+[0,1];
            elseif p==3 % up and right
                newpos=pos+[1,1];
            elseif p==4 % left
                newpos=pos+[-1,0];
            elseif p==5 % no movement
                newpos=pos;
            elseif p==6 % right
                newpos=pos+[1,0];
            elseif p==7 % left and down
                newpos=pos+[-1,-1];
            elseif p==8 % down
                newpos=pos+[0,-1];
            elseif p==9 % down and left
                newpos=pos+[1,-1];
            end

           % check if new position is out of the lattice in order to correct it
            if newpos(1)==0
                newpos(1)=1;
            elseif newpos(1)==L1+1
                newpos(1)=L1;
            end
            if newpos(2)==0
                newpos(2)=1;
            elseif newpos(2)==L2+1
                newpos(2)=L2;
            end

           % transition will be only made if new cell is free!
           if checkfree(newpos, field)
               field(newpos(1),newpos(2))=field(pos(1),pos(2)); % interchange 0 to the free cell and previous value to new cell
               field(pos(1),pos(2))=0;
               preyspos(k,:)=newpos;
           end
        end  
    end
    % Moving predators
    for k=1:npredators
        pos=predatorspos(k,:); % position of the individual
        if pos(1)~=0  % only if individual is not at the cementery we move it
            
            % p is random number between 1-9
            p=floor(rand*9)+1;
            % each number represent a movement according to:
            %     1 2 3
            %     4 5 6
            %     7 8 9
            % where the individual is in the 5 cell

            if p==1 % up and left
               newpos=pos+[-1,1];    
            elseif p==2 % up
                newpos=pos+[0,1];
            elseif p==3 % up and right
                newpos=pos+[1,1];
            elseif p==4 % left
                newpos=pos+[-1,0];
            elseif p==5 % no movement
                newpos=pos;
            elseif p==6 % right
                newpos=pos+[1,0];
            elseif p==7 % left and down
                newpos=pos+[-1,-1];
            elseif p==8 % down
                newpos=pos+[0,-1];
            elseif p==9 % down and left
                newpos=pos+[1,-1];
            end

           % check if new position is out of the lattice in order to correct it
            if newpos(1)==0
                newpos(1)=1;
            elseif newpos(1)==L1+1
                newpos(1)=L1;
            end
            if newpos(2)==0
                newpos(2)=1;
            elseif newpos(2)==L2+1
                newpos(2)=L2;
            end

           % transition will be only made if new cell is free!
           if checkfree(newpos, field)
               field(newpos(1),newpos(2))=field(pos(1),pos(2)); % interchange 0 to the free cell and previous value to new cell
               field(pos(1),pos(2))=0;
               predatorspos(k,:)=newpos;
           end
        end  
    end
   
end

close(w)

return