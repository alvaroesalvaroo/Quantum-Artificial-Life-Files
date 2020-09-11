function field=fillfield2(L1,L2,preyspos,predatorspos,szpredators,szpreys,deathvalue)

    field=zeros(L1,L2);
    size(preyspos);
    npreys=ans(1);
    size(predatorspos);
    npredators=ans(1);
    
    for k=1:npreys
        field(preyspos(k,1),preyspos(k,2))=1+szpreys(k)/2;
    end
                 
    for k=1:npredators
        field(predatorspos(k,1),predatorspos(k,2))=2+szpredators(k)/2;
    end            
return 
