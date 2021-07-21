%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
clear
clc
close all
tic
%% 用importdata这个函数来读取文件
c101 = importdata('c101.txt');
cap = 200;                                                        %车辆最大装载量
%% 提取数据信息
E = c101(1,5);                                                    %配送中心时间窗开始时间
L = c101(1,6);                                                    %配送中心时间窗结束时间
vertexs = c101(:,2:3);                                            %所有点的坐标x和y
customer = vertexs(2:end,:);                                      %顾客坐标
cusnum = size(customer,1);                                        %顾客数
v_num = 25;                                                       %车辆最多使用数目
demands = c101(2:end,4);                                          %需求量
a = c101(2:end,5);                                                %顾客时间窗开始时间[a[i],b[i]]
b = c101(2:end,6);                                                %顾客时间窗结束时间[a[i],b[i]]
width = b-a;                                                      %顾客的时间窗宽度
s = c101(2:end,7);                                                %客户点的服务时间
h = pdist(vertexs);
dist = squareform(h);                                             %距离矩阵
%% 初始化参数
m = 50;                                                           %蚂蚁数量
alpha = 1;                                                        %信息素重要程度因子
beta = 3;                                                         %启发函数重要程度因子
gama = 2;                                                         %等待时间重要程度因子
delta = 3;                                                        %时间窗跨度重要程度因子
r0 = 0.5;                                                         %r0为用来控制转移规则的参数
rho = 0.85;                                                       %信息素挥发因子
Q = 5;                                                            %更新信息素浓度的常数
Eta = 1./dist;                                                    %启发函数
Tau = ones(cusnum+1,cusnum+1);                                    %信息素矩阵
Table = zeros(m,cusnum);                                          %路径记录表
iter = 1;                                                         %迭代次数初值
iter_max = 100;                                                   %最大迭代次数
Route_best = zeros(iter_max,cusnum);                              %各代最佳路径
Cost_best = zeros(iter_max,1);                                    %各代最佳路径的成本
%% 迭代寻找最佳路径
while iter<=iter_max
    %% 先构建出所有蚂蚁的路径
    %逐个蚂蚁选择
    for i=1:m
        %逐个顾客选择
        for j=1:cusnum
            r=rand;                                             %r为在[0,1]上的随机变量
            np=next_point(i,Table,Tau,Eta,alpha,beta,gama,delta,r,r0,a,b,width,s,L,dist,cap,demands);
            Table(i,j)=np;
        end
    end
    %% 计算各个蚂蚁的成本=1000*车辆使用数目+车辆行驶总距离
    cost=zeros(m,1);
    NV=zeros(m,1);
    TD=zeros(m,1);
    for i=1:m
        VC=decode(Table(i,:),cap,demands,a,b,L,s,dist);
        [cost(i,1),NV(i,1),TD(i,1)]=costFun(VC,dist);
    end
    %% 计算最小成本及平均成本
    if iter == 1
        [min_Cost,min_index]=min(cost);
        Cost_best(iter)=min_Cost;
        Route_best(iter,:)=Table(min_index,:);
    else
        [min_Cost,min_index]=min(cost);
        Cost_best(iter)=min(Cost_best(iter - 1),min_Cost);
        if Cost_best(iter)==min_Cost
            Route_best(iter,:)=Table(min_index,:);
        else
            Route_best(iter,:)=Route_best((iter-1),:);
        end
    end
    %% 更新信息素
    bestR=Route_best(iter,:);
    [bestVC,bestNV,bestTD]=decode(bestR,cap,demands,a,b,L,s,dist);
    Tau=updateTau(Tau,bestR,rho,Q,cap,demands,a,b,L,s,dist);
    %% 打印当前最优解
    disp(['第',num2str(iter),'代最优解:'])
    disp(['车辆使用数目：',num2str(bestNV),'，车辆行驶总距离：',num2str(bestTD)]);
    fprintf('\n')
    %% 迭代次数加1，清空路径记录表
    iter=iter+1;
    Table=zeros(m,cusnum);
end
%% 结果显示
bestRoute=Route_best(end,:);
[bestVC,NV,TD]=decode(bestRoute,cap,demands,a,b,L,s,dist);
draw_Best(bestVC,vertexs);
%% 绘图
figure(2)
plot(1:iter_max,Cost_best,'b')
xlabel('迭代次数')
ylabel('成本')
title('各代最小成本变化趋势图')
%% 判断最优解是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
flag=Judge(bestVC,cap,demands,a,b,L,s,dist);
%% 检查最优解中是否存在元素丢失的情况，丢失元素，如果没有则为空
DEL=Judge_Del(bestVC);
toc