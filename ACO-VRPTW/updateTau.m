% update the pheromone on the edge of the best route 
% Input:
% Tau, the pheromone
% bestR, the best route
% rho, the pheromone evaporation rate, it should be (1 - rho)
% Q, a constant

function Tau = updateTau(Tau, bestR, rho, Q, a, b, L, s, dist)
    [~, ~, bestTD] = decode(bestR, a, b, L, s, dist);
    cusnum = size(dist,1) - 1;
    delta_tau_matrix = zeros(cusnum + 1, cusnum + 1);
    delta_tau = Q / bestTD;
    % update Tau
    for i = 1 : cusnum - 1
        delta_tau_matrix(bestR(i), bestR(i+1)) = delta_tau_matrix(bestR(i), bestR(i+1)) + delta_tau;
        Tau(bestR(i), bestR(i+1)) = rho * Tau(bestR(i), bestR(i+1)) + delta_tau_matrix(bestR(i), bestR(i+1));
    end
    % the egde back to the depot
    delta_tau_matrix(bestR(cusnum), 1) = delta_tau_matrix(bestR(cusnum), 1) + delta_tau;
    Tau(bestR(cusnum), 1) = rho * Tau(bestR(i), 1) + delta_tau_matrix(bestR(cusnum), 1);
end
