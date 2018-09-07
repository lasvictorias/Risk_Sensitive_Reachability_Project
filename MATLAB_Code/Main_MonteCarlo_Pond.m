%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Computes J0(x,y) := min_pi CVaR_y[ COST(x0, ..., xN) | x0 = x, pi ] via Monte Carlo for pond example
    % COST(x0, ..., xN) = exp(m*g(x0)) + ... + exp(m*g(xN)) "cost_sum" or
    %                   = max{ g(xk) : k = 0,...,N } "cost_max";
    % g: signed distance function w.r.t constraint set
% AUTHOR: Margaret Chapman
% DATE: September 6, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clearvars; clc;

Setup_Pond_Example;             % provides grid, constraint set, soft-max parameter, probability distribution, horizon, etc.

type_sum = 0;                   % choose 1 if cost_sum, choose 0 if cost_max

J0_MonteCarlo = MonteCarlo_CVaR_pond( type_sum, xs, ls, ws, P, m, N, dt, A ); 

figure; FigureSettings; mesh( X, L, J0_MonteCarlo ); 

if type_sum, title(['Monte Carlo (soft max, m = ', num2str(m), ')']); else, title('Monte Carlo (max)'); end

xlabel('State, x'); ylabel('Confidence level, y'); zlabel(['J_0', '(x,y)']);

%index_clip = 56; %xs(56) = 5.5ft, clip so we don't analyze inaccuracies near boundary of grid?
% mesh( X(:,1:index_clip), L(:,1:index_clip), J0_MonteCarlo(:,1:index_clip) );







