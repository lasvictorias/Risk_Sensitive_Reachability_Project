%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Analysis of results, pond example
% AUTHOR: Margaret Chapman
% DATE: September 6, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compares [Monte Carlo, max] vs. [Dynamic Programming, soft-max] 

close all; clearvars; clc;

% Results from Main_MonteCarlo_Pond.m, type_sum = 0, g(x) = x - 5 
% J0(x,y) := min_pi CVaR_y[ max{ g(xk) : k = 0,...,N } | x0 = x, pi ] via Monte Carlo for pond example
% Added zero-mean Gaussian noise with small standard deviation (10^-12) to cost realization 
load('Pond_Results\monte_carlo_max_pond_results\monte_carlo_max_nt1million.mat'); 
J0_cost_max_MORE = J0_MonteCarlo; % nt = 10^6, trials per (x,y)

load('Pond_Results\monte_carlo_max_pond_results\monte_carlo_nt100000\monte_carlo_max_nt100000.mat');
J0_cost_max_LESS = J0_MonteCarlo; % nt = 100 thousand, trials per (x,y) 

diff = abs( J0_cost_max_MORE - J0_cost_max_LESS ); mc_max_diff = max( diff(:) ); % is equal to 0.0272


% Results from Main_DynamicProgramming_Pond.m, m = 10, beta = 10^(-3), g(x) = x - 5
% J0(x,y) := min_pi CVaR_y[ beta*exp(m*g(x0)) + ... + beta*exp(m*g(xN)) | x0 = x, pi ] via dynamic programming for pond example
load('Pond_Results\dyn_prog_m10_beta10minus3_mosektry\dyn_prog_m10_beta10minus3_gline.mat');
J0_cost_sum = Js{1}; beta = 10^(-3); % see stage_cost_pond.m


rs = [ 1, 0.5, 0.25, 0, -0.25, -0.5 ]; % risk levels to be plotted

[ U, S_MORE ] = getRiskySets_pond( ls, xs, rs, m, J0_cost_sum, J0_cost_max_MORE, beta, 1 );

[ U, S_LESS ] = getRiskySets_pond( ls, xs, rs, m, J0_cost_sum, J0_cost_max_LESS, beta, 2 );

for r_index = 1 : length(rs) 
    for l_index = 1 : length(ls)
        if ~isequal( S_MORE{r_index}{l_index}, S_LESS{r_index}{l_index} ) 
            disp( ['S_MORE, S_LESS do not match at y = ', num2str(ls(l_index)), ' r = ', num2str(rs(r_index))] );
            state_diff = setdiff( S_LESS{r_index}{l_index}, S_MORE{r_index}{l_index} ); 
            disp( ['S_LESS contains x = ', num2str(state_diff), ' but, S_MORE does not.'] );
        end
    end
end
% Risk-sensitive safe sets generated by Monte Carlo (S_MORE: nt = 1 million; S_LESS: nt = 100 thousand )
% are quite similar. So, we will report the results for the fewer iterations.
% In particular, for our risk levels and confidence levels, they differed at one state.
% x = 1.6 \in risk-sensitive set, nt = 100 thousand, r = 1, y = 0.001
% x = 1.6 \notin risk-sensitive safe set, nt = 1 million, r = 1, y = 0.001



