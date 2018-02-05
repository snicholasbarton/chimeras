p=1:5:40;
all_sigma=linspace(1,3.5,length(p));
state=zeros(length(p));

for i=1:length(p)
    P=p(i);
    for j=1:length(p)
        sigma=all_sigma(j);
        state(j,i) = Chimera(P,sigma);
    end
end
imagesc(state)