function state = classify(X)
%classify Summary of this function goes here N.B. enumeration of different
% states found in classify.m source code comments
% INPUT:
%   X: the output of our odesolve
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
H = X(:,Nh+1:N);

% discard burn-in/transients
V = V(3*end/4:end);
H = H(3*end/4:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find the different states and initialise flags of identified states %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find death states indices
Dv = find_death(V);

% find non-zero steady states indices
all_SSv = find_SS(V); % finds all steady states
SSv = setdiff(all_SSv,Dv); % just non-zero steady states

% find chaotic nodes/indices
Zv = find_chaos(V);

% find the dominant frequencies in the data
freqvec = dominating_freqs(V);

% flags: 1 if state exists in V, 0 if it does not
death_flag = ~isempty(Dv);
steady_flag = ~isempty(SSv);
chaos_flag = ~isempty(Zv);
FC_flag = 0;
AC_flag = 0;

% % number of nodes exhibiting distinct behaviours, can hopefully be replaced
% % by flags with clever coding
% N_dead = length(Dv);
% N_steady = length(SSv);
% N_chaotic = length(Zv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Classify states via enumeration %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if N_dead == 100
%     state = 1; % the all-dead state
% elseif N_steady == 100
%     state = 2; % the all-non-zero-steady state
% elseif N_dead + N_steady == 100
%     state = 3; % all steady, mixed death state
% % remaining cases have non-steady states
% elseif N_chaotic == 100
%     state = 4; % the all-chaotic state
% elseif N_dead + N_chaotic
% 
%     
%     
%     
state = flags2state([AC_flag;FC_flag;chaos;steady_flag;death_flag]);
end

% % enumeration of different states
% 0: sync
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
