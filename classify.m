function state = classify(T,X,A)
%classify Summary of this function goes here N.B. enumeration of different
% states found in classify.m source code comments
% INPUT:
%   T: the time output of our odesolve
%   X: the solution output of our odesolve
%   A: the adjacency matrix
% OUTPUT:
%   state: the state of the system

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Set up the problem and format our data correctly %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% X is of dimension (time x nodes * 2) so num nodes Nh is size(X)(2)/2
N = size(X,2);
Nh = N/2;

% separate for convenience
V = X(:,1:Nh);

% discard burn-in/transients
V = V(round(3*end/4):end,:);
T = T(round(3*end/4):end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find the different states and initialise flags of identified states %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find death states indices
Dv = find_death(V); % dead steady states

% find non-zero steady states indices
SSv = find_SS(V); % all steady states
NZSSv = setdiff(SSv,Dv); % non-zero steady states

% find chaotic nodes/indices
Zv = find_chaos(V);

% V with steadys, chaos removed
% non_steadys_indices = setdiff(1:100,SSv);
% non_chaotic_indices = setdiff(1:100,Zv);
non_steadys_non_chaotic_indices = setdiff(1:100,union(Zv,SSv));
% non_steadys = V(:,non_steadys_indices);
non_steadys_non_chaotic = V(:,non_steadys_non_chaotic_indices);

% flags: 1 if state exists in V, 0 if it does not
sync_flag = 0;
death_flag = ~isempty(Dv);
NZsteady_flag = ~isempty(NZSSv);
chaos_flag = ~isempty(Zv);
AC_flag = 0;
FC_flag = 0;

% number of nodes exhibiting non-oscillatory behaviour, to reduce
% computational burden
N_dead = length(Dv);
N_steady = length(NZSSv);
N_chaotic = length(Zv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Classify states via enumeration %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if N_dead == Nh
    state = 1; % death
elseif N_steady == Nh
    state = 2; % nonzero-steady
elseif N_dead + N_steady == Nh
    state = 3; % nonzero-steady and death
elseif N_chaotic == Nh
    state = 4; % chaos
elseif N_dead + N_chaotic == Nh
    state = 5; % chaos and death
elseif N_steady + N_chaotic == Nh
    state = 6; % chaos and nonzero-steady
elseif N_dead + N_steady + N_chaotic == Nh
    state = 7; % chaos and nonzero-steady and death
else % we need to check the oscillating nodes
    
    % find the frequencies in the data, find FC and return the freq bins
    freqvec = findFreqs(non_steadys_non_chaotic,T);
    [freqstates_flag, n, bin] = find_FC(freqvec,A,non_steadys_non_chaotic_indices);
     
    % assign the flags correctly - sync and FC never overlap!
    if freqstates_flag == 1
        sync_flag = 1;
    elseif freqstates_flag == 2
        FC_flag = 1;
    end
    
    % and now check for AC in the bins
    if sync_flag == 1
        if find_ac(non_steadys_non_chaotic,A,non_steadys_non_chaotic_indices) == 1
            sync_flag = 0; % we can't have sync if there's AC!
            AC_flag = 1;
        end
    elseif FC_flag == 1
        banks = sepFreqs(n,bin,non_steadys_non_chaotic_indices);
        for i = 1:length(banks)
            if find_ac(V(:,banks{i}),A,banks{i}) == 1
                sync_flag = 0; % we can't have sync if there's AC!
                AC_flag = 1;
                break
            end
        end
    end
      
    % classify the state from the flags
    state = flags2state([sync_flag;AC_flag;FC_flag;chaos_flag;NZsteady_flag;death_flag]);
    
end

% % enumeration of different states
% 0: all sync (default assumption if nothing found)
% 1: death
% 2: nonzero-steady
% 3: nonzero-steady and death
% 4: chaos
% 5: chaos and death
% 6: chaos and nonzero-steady
% 7: chaos and nonzero-steady and death
% 8: frequency chimera
% 9: frequency chimera and death
% 10: frequency chimera and nonzero-steady
% 11: frequency chimera and nonzero-steady and death
% 12: frequency chimera and chaos
% 13: frequency chimera and chaos and death
% 14: frequency chimera and chaos and nonzero-steady
% 15: frequency chimera and chaos and nonzero-steady and death
% 16: amplitude chimera
% 17: amplitude chimera and death
% 18: amplitude chimera and nonzero-steady
% 19: amplitude chimera and nonzero-steady and death
% 20: amplitude chimera and chaos
% 21: amplitude chimera and chaos and death
% 22: amplitude chimera and chaos and nonzero-steady
% 23: amplitude chimera and chaos and nonzero-steady and death
% 24: amplitude chimera and frequency chimera
% 25: amplitude chimera and frequency chimera and death
% 26: amplitude chimera and frequency chimera and nonzero-steady
% 27: amplitude chimera and frequency chimera and nonzero-steady and death
% 28: amplitude chimera and frequency chimera and chaos
% 29: amplitude chimera and frequency chimera and chaos and death
% 30: amplitude chimera and frequency chimera and chaos and nonzero-steady
% 31: amplitude chimera and frequency chimera and chaos and nonzero-steady and death
% 32: sync
% 33: sync and death
% 34: sync and nonzero-steady
% 35: sync and nonzero-steady and death
% 36: sync and chaos
% 37: sync and chaos and death
% 38: sync and chaos and nonzero-steady
% 39: sync and chaos and nonzero-steady and death
% 40: synchronised chaos and chaos (manual)
% 41: synchronised chaos and non-zero steady (manual)
