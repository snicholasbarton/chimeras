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

% X is of dimension (time x nodes) so num nodes is size(X)(2)
S = size(X);
N = S(2);
Nh = N/2;

% separate for convenience
V = X(:,1:Nh);

% discard burn-in/transients
V = V(round(3*end/4):end,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find the different states and initialise flags of identified states %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find death states indices
Dv = find_death(V);

% find non-zero steady states indices
all_SSv = find_SS(V); % finds all steady states
SSv = setdiff(all_SSv,Dv); % just non-zero steady states

% make a non-steady V
steadys = union(Dv,SSv);
non_steadys_indices = setdiff(1:100,steadys);
non_steadys = V(:,non_steadys_indices);

% find chaotic nodes/indices
Zv = find_chaos(V);

% flags: 1 if state exists in V, 0 if it does not
sync_flag = 0;
death_flag = ~isempty(Dv);
steady_flag = ~isempty(SSv);
chaos_flag = ~isempty(Zv);
FC_flag = 0;
AC_flag = 0;

% number of nodes exhibiting non-oscillatory behaviour, to reduce
% computational burden
N_dead = length(Dv);
N_steady = length(SSv);
N_chaotic = length(Zv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Classify states via enumeration %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if N_dead == 100
    state = 1; % death
elseif N_steady == 100
    state = 2; % nonzero-steady
elseif N_dead + N_steady == 100
    state = 3; % nonzero-steady and death
elseif N_chaotic == 100
    state = 4; % chaos
elseif N_dead + N_chaotic == 100
    state = 5; % chaos and death
elseif N_steady + N_chaotic == 100
    state = 6; % chaos and nonzero-steady
elseif N_dead + N_steady + N_chaotic == 100
    state = 7; % chaos and nonzero-steady and death
else % we need to check the oscillating nodes
    % find the dominant frequencies in the data
    freqvec = dominating_freqs(T,non_steadys);
    freqstates_flag = classify_freqs(freqvec,A,non_steadys_indices);
    
    if freqstates_flag == 1
        sync_flag = 1;
    elseif freqstates_flag == 2
        FC_flag = 1;
    end
    
    AC_flag = find_ac(non_steadys,A,non_steadys_indices);
    
    % vile, vile switches for sync + no FC/AC
    if sync_flag
        if death_flag
            if steady_flag
                if chaos_flag
                    state = 36;
                end
                state = 35;
            end
            state = 32;
        elseif steady_flag
            if chaos_flag
                state = 37;
            end
            state = 33;
        elseif chaos_flag
            if death_flag
                state = 38;
            end
            state = 34;
        end
    end
    % run the frequency classification
    state = flags2state([AC_flag;FC_flag;chaos;steady_flag;death_flag]);
end

end

% % enumeration of different states
% 0: all sync
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
% 32: sync and death
% 33: sync and nonzero-steady
% 34: sync and chaos
% 35: sync and death and nonzero-steady
% 36: sync and death and nonzero-steady and chaos
% 37: sync and nonzero-steady and chaos
% 38: sync and chaos and death
