function state = find_ac(V,A,I)

% function that checks if there is amplitude chimera

% V: only oscillating nodes
% I: indeces of oscillating nodes
    
% state 1: Yes      
% state 0: No

%%%%%%%%%%%%% CLASSIFICATION %%%%%%%%%% 

amplvec=range(V);

state=0;

if range(amplvec)>10^(-4) % if there is more than one amplitude
    [n, bin] = histc(amplvec, uniquetol(amplvec,1e-4));
    multiplevec = find(n > 1);
    
    for i =1:length(multiplevec)
        multiple=multiplevec(i);
        index2 = I(ismember(bin, multiple));
        
        logical=A(index2,index2);
        logical=logical(:);
        
        if any(logical)==1
            state=1; % amplitude chimera
            break
        end
    end
end

end