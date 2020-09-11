function plotlattice(field)
[N,M]=size(field);
for i=1:N+1
        plot([i-0.5,i-0.5],[0.5,M+0.5],'-k')
        hold on
    end

    for i=1:M+1
        plot([0.5,N+0.5],[i-0.5,i-0.5],'-k')
    end
    for i=1:N
        for j=1:M
            if field(i,j)<1.5 && field(i,j)>0.5% prey
                rectangle('Position',[i-0.25 j-0.25 0.5 0.5],'Curvature',[1 1],'FaceColor',[0,0,field(i,j)-0.5])
            elseif field(i,j)>1.5 % predator
                rectangle('Position',[i-0.25 j-0.25 0.5 0.5],'FaceColor',[(field(i,j)-1.5)*5,0,0])
            end
        end
    end
end