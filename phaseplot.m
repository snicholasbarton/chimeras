Pvec=[1];
sigmavec=[1.7];
state=zeros(length(Pvec));

for i=1:length(Pvec)
    P=Pvec(i);
    for j=1:length(sigmavec)
        sigma=sigmavec(j);
        state(j,i) = Chimera(P,sigma);
    end
end
imagesc(state)