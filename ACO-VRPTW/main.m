clear; clc; close all;
%% input 
c101 = importdata('c101.txt');
depot_time_window1 = c101(1,5); % time window of depot
depot_time_window2 = c101(1,6);
vertexs = c101(:,2:3); 
customer = vertexs(2:end,:); % customer locations
customer_number = size(customer,1);
% vehicle_number = 25;
time_window1 = c101(2:end,5);
time_window2 = c101(2:end,6);
width = time_window2-time_window1; % width of time window
service_time = c101(2:end,7); 
h = pdist(vertexs);
dist = squareform(h); % distance matrix
%% initialize the parameters
ant_number = 15;                                                  % number of ants
alpha = 1;                                                        % parameter for pheromone
beta = 3;                                                         % paremeter for heuristic information
gamma = 2;                                                        % parameter for waiting time
delta = 3;                                                        % parameter for width of time window
r0 = 0.5;                                                         % a constant to control the movement of ants
rho = 0.85;                                                       % pheromone evaporation rate
Q = 5;                                                            % a constant to influence the update of pheromene
Eta = 1./dist;                                                    % heuristic function
iter = 1;                                                         % initial iteration number
iter_max = 50;                                                    % maximum iteration number

Tau = ones(customer_number+1,customer_number+1);                  % a matrix to store pheromone
Table = zeros(ant_number,customer_number);                        % a matrix to save the route
Route_best = zeros(iter_max,customer_number);                     % the best route
Cost_best = zeros(iter_max,1);                                    % the cost of best route
%% find the best route 
while iter <= iter_max
    % ConstructAntSolutions
    for i = 1:ant_number
        for j = 1:customer_number
            r = rand;
            np = NextPoint(i,Table,Tau,Eta,alpha,beta,gamma,delta,r,r0,time_window1,time_window2,width,service_time,depot_time_window2,dist);
            Table(i,j) = np;
        end
    end
    %% calculate the cost for each ant
    cost = zeros(ant_number,1);
    NV = zeros(ant_number,1);
    TD = zeros(ant_number,1);
    for i=1:ant_number
        VC = decode(Table(i,:),time_window1,time_window2,depot_time_window2,service_time,dist);
        [cost(i,1),NV(i,1),TD(i,1)] = CostFun(VC,dist);
    end
    %% find the minimal cost and the best route
    if iter == 1
        [min_Cost,min_index] = min(cost);
        Cost_best(iter) = min_Cost;
        Route_best(iter,:) = Table(min_index,:);
    else
        % compare the min_cost in this iteration with the last iter
        [min_Cost,min_index] = min(cost);
        Cost_best(iter) = min(Cost_best(iter - 1),min_Cost); 
        if Cost_best(iter) == min_Cost
            Route_best(iter,:) = Table(min_index,:);
        else
            Route_best(iter,:) = Route_best((iter-1),:);
        end
    end
    %% update the pheromene
    bestR = Route_best(iter,:); % find out the best route
    [bestVC,bestNV,bestTD] = decode(bestR,time_window1,time_window2,depot_time_window2,service_time,dist); 
    Tau = UpdateTau(Tau,bestR,rho,Q,time_window1,time_window2,depot_time_window2,service_time,dist);
    %% print 
    disp(['Iterration: ',num2str(iter)])
    disp(['Number of Robots: ',num2str(bestNV),', Total Distance: ',num2str(bestTD)]);
    fprintf('\n')
    %
    iter = iter+1;
    Table = zeros(ant_number,customer_number);
end
%% draw
bestRoute=Route_best(end,:);
[bestVC,NV,TD]=decode(bestRoute,time_window1,time_window2,depot_time_window2,service_time,dist);
draw_Best(bestVC,vertexs);
figure(2)
plot(1:iter_max,Cost_best,'b')
xlabel('Iteration')
ylabel('Cost')
title('Change of Cost')
%% check the constraints, 1 == no violation
flag = Check(bestVC,time_window1,time_window2,depot_time_window2,service_time,dist)








