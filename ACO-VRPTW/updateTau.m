function Tau=updateTau(Tau,bestR,rho,Q,a,b,L,s,dist)
    [bestVC,bestNV,bestTD] = decode(bestR,a,b,L,s,dist);
    cusnum = size(dist,1)-1;
    Delta_Tau_matrix = zeros(cusnum+1,cusnum+1);
    delta_Tau = Q/bestTD;
    for j = 1:cusnum-1
        Delta_Tau_matrix(bestR(j),bestR(j+1)) = Delta_Tau_matrix(bestR(j),bestR(j+1)) + delta_Tau;
        Tau(bestR(j),bestR(j+1)) = rho*Tau(bestR(j),bestR(j+1)) + Delta_Tau_matrix(bestR(j),bestR(j+1));
    end
    Delta_Tau_matrix(bestR(cusnum),1) = Delta_Tau_matrix(bestR(cusnum),1)+delta_Tau;
    Tau(bestR(cusnum),1) = rho*Tau(bestR(cusnum),1)+Delta_Tau_matrix(bestR(cusnum),1);
end