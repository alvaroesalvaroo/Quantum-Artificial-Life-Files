function sz=szcalc(filename)
%  This function returns <Sz> of all individual using the name of a .txt
%  data file with binary data

f=fopen(filename);


A=textscan(f,'%q','Delimiter',',');
fclose(f);
data=A{1,1};
data=erase(data,"'");
data=erase(data,'"');
data=erase(data,":");
data=erase(data,"{");
data=erase(data,"}");
A1=zeros(length(data),1);
A2=zeros(length(data),1);
dec=zeros(length(data),1);
 
for k=1:length(data)
    u=split(data(k));  
    A1(k)=str2num(u{1});
    dec(k)=bin2dec(u{1});
    A2(k)=str2num(u{2});
end
N=length(u{1});
bin=zeros(length(data),N);
oldA2=A2;
% aqui convertimos A1 (numero binario pero guardado como decimal) a 2N
% numeros binarios. bin es una matriz con N??¿?¿ digitos (0 o 1) por cada numero
for k=1:length(data)
    for j=1:N
        if mod(A1(k),2)==1
            bin(k,N+1-j)=1;
            A1(k)=A1(k)-1;
        end
        A1(k)=A1(k)/10;
    end
end

c=A2; % counts
totalc=c; %let us store here the non-normalized counts
c=c/sum(c); % normalize c
x=dec; % values of k
sz=zeros(1,N);
for j=1:N
    sz(j)=sum((c.*(bin(:,j)*2-1))); % important line *(-2)+1
    % if 0-> 0*(2)-1=-1
    %    1-> 1*(2)-1=1
end

sz=flip(sz) %important line



return