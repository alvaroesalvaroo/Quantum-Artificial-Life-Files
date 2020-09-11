function [interactions,preys,predators]=test(preys,predators,sz,step,showplot,N,M)

nint=0; % we inizialice it at 0
interactions=zeros(1,3); % first 2 rows indicate which individuals are interacting, last row indicate the step at which they interact
% sz=fliplr(sz); % we have to flip sz since it is reverted. Como Arturo
% perez reverted. Last version does not reverted to Arturo

% CONVERT 'MANUALLY' PYTHON CELLS TO MATLAB MATRICES. I wish there was a
% better way but i couldnt find it

mpreys=zeros(length(preys),2);
for i=1:length(preys)
    for j=1:2
        mpreys(i,j)=preys{i}{j};
    end
end


mpredators=zeros(length(predators),2);
for i=1:length(predators)
    for j=1:2
        mpredators(i,j)=predators{i}{j};
    end
end

field=zeros(N,M);
% 0=void, 0.5<=prey<1.5, 1.5<=predator<2.5

% initial individuals
% each row represents the 2 components of the individual


size(mpreys);
npreys=ans(1); % number of preys
size(mpredators);
npredators=ans(1); % number of predators
indiv=[mpredators; mpreys]; % all individuals in one array. DEBUGING HERE
nindiv=npredators+npreys; % number of individuals

for k=1:npreys
    if mpreys(k,1)~=0
        field(mpreys(k,1),mpreys(k,2))=1+sz(npredators+k)/2;
    end
    % asign a value to the cells with alive prey
end


for k=1:npredators
    if mpredators(k,1)~=0
        field(mpredators(k,1),mpredators(k,2))=2+sz(k)/2;
    end
    % asign a value to the cells with alive pred
end

for k=1:nindiv
    pos=indiv(k,:); % position of the individual
    
    if pos(1)~=0  % only if individual is not at the cementery
        % p is random number between 1-9
        p=round(rand*8)+1;
        % each number represent a movement according to:
        %     1 2 3
        %     4 5 6
        %     7 8 9
        % where the individual is in the 5 cell
        % if grid ends, we will corect movement

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

       % check if new pos is out of the array in order to correct it
        if newpos(1)==0
            newpos(1)=1;
        elseif newpos(1)==N+1
            newpos(1)=N;
        end
        if newpos(2)==0
            newpos(2)=1;
        elseif newpos(2)==M+1
            newpos(2)=M;
        end

       % transition will be only made if new cell is free!
       if field(newpos(1),newpos(2))==0
           aux=field(pos(1),pos(2));
           field(newpos(1),newpos(2))=aux; % interchange 0 to the free cell and previous value to new cell
           field(pos(1),pos(2))=0;
           indiv(k,:)=newpos;
       end
    end  
end
% checking if there are interactions
for k=1:nindiv-1
        for j=k+1:nindiv
            if (norm(indiv(k,:)-indiv(j,:))<1.5) && (indiv(k,1)~=0) && (indiv(j,1)~=0)
                % this condition ensures that both individuals are at
                % continous cells, since the norm of their difference
                % vector is sqrt(2) or less
                % We also heck that individuals are not at cementery
          
                if (field(indiv(j,1),indiv(j,2))~=field(indiv(k,1),indiv(k,2)))
                    % this condition ensures that they are not both preys
                    % or both predators
                    nint=nint+1; % we have an interaction!
                    interactions(nint,1)=k;
                    interactions(nint,2)=j;
                    % this is the number of the step
                end
            end
        end

end

% preys and predator matrix has been modified
for k=1:npreys
    mpreys(k,:)=indiv(npredators+k,:);
end
for k=1:npredators
    mpredators(k,:)=indiv(k,:);
end

% and now, let us recover the class of matrices that python like:

for i=1:length(preys)
    for j=1:2
        preys{i}{j}=mpreys(i,j);
    end
end


for i=1:length(predators)
    for j=1:2
        predators{i}{j}=mpredators(i,j);
    end
end

if showplot==true
    % Now is time to draw a cool plot, where preys are blue circles and
    % predators red squares
    % artificial grid
    close
    h=figure;

    for i=1:N+1
        plot([i-0.5,i-0.5],[0.5,M+0.5],'-k')
        hold on
    end

    for i=1:M+1
        plot([0.5,N+0.5],[i-0.5,i-0.5],'-k')
    end
    for i=1:N
        for j=1:M
            if field(i,j)<1.5 && field(i,j)>=0.5% prey
                rectangle('Position',[i-0.25 j-0.25 0.5 0.5],'Curvature',[1 1],'FaceColor',[0,0,field(i,j)-0.5])
            elseif field(i,j)>=1.5 % predator
                rectangle('Position',[i-0.25 j-0.25 0.5 0.5],'FaceColor',[field(i,j)-1,0,0])
            end
        end
    end
    % is it posible to save the image?
    % Capture the plot as an image
    axis tight manual
    drawnow
    filename = 'movement2.gif';

    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
          % Write to the GIF File 
    if step == 0
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end
    if step==40 % this is just an option
        hold off
    end
end

return