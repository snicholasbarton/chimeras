function state = flags2state(flags)
%flags2state Converts a list of flags to a state value
% INPUTS:
%   flags: a list of 0-1 flags 
% OUTPUTS:
%   state: a numeric value corresponding to the state of the 

state_bin_str = num2str(flags(1));

for i = 2:length(flags)
    state_bin_str = strcat(state_bin_str,num2str(flags(i)));
end

state = bin2dec(state_bin_str);
end

