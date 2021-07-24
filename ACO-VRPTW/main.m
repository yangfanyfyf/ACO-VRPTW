
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
%% 初始化参数
ant_number = 15;                                                           %蚂蚁数量
alpha = 1;                                                        %信息素重要程度因子
beta = 3;                                                         %启发函数重要程度因子
gama = 2;                                                         %等待时间重要程度因子
delta = 3;                                                        %时间窗跨度重要程度因子
r0 = 0.5;                                                         %r0为用来控制转移规则的参数
rho = 0.85;                                                       %信息素挥发因子
Q = 5;                                                            %更新信息素浓度的常数
Eta = 1./dist;                                                    %启发函数
Tau = ones(customer_number+1,customer_number+1);                                    %信息素矩阵
Table = zeros(ant_number,customer_number);                                          %路径记录表
iter = 1;                                                         %迭代次数初值
iter_max = 50;                                                   %最大迭代次数
Route_best = zeros(iter_max,customer_number);                              %各代最佳路径
Cost_best = zeros(iter_max,1);                                    %各代最佳路径的成本
%% 迭代寻找最佳路径
while iter<=iter_max
    %% 先构建出所有蚂蚁的路径
    %逐个蚂蚁选择
    for i=1:ant_number
        %逐个顾客选择
        for j=1:customer_number
            r=rand;                                             %r为在[0,1]上的随机变量
            np=next_point(i,Table,Tau,Eta,alpha,beta,gama,delta,r,r0,time_window1,time_window2,width,service_time,depot_time_window2,dist);
            Table(i,j)=np;
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
    %% 计算最小成本及平均成本
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
    Tau = updateTau(Tau,bestR,rho,Q,time_window1,time_window2,depot_time_window2,service_time,dist);
    %% 打印当前最优解
    disp(['第',num2str(iter),'代最优解:'])
    disp(['车辆使用数目：',num2str(bestNV),'，车辆行驶总距离：',num2str(bestTD)]);
    fprintf('\n')
    %% 迭代次数加1，清空路径记录表
    iter=iter+1;
    Table=zeros(ant_number,customer_number);
end
%% 结果显示
bestRoute=Route_best(end,:);
[bestVC,NV,TD]=decode(bestRoute,time_window1,time_window2,depot_time_window2,service_time,dist);
draw_Best(bestVC,vertexs);
%% 绘图
figure(2)
plot(1:iter_max,Cost_best,'b')
xlabel('迭代次数')
ylabel('成本')
title('各代最小成本变化趋势图')
%% 判断最优解是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
flag=Judge(bestVC,time_window1,time_window2,depot_time_window2,service_time,dist)
%% 检查最优解中是否存在元素丢失的情况，丢失元素，如果没有则为空
DEL=Judge_Del(bestVC);