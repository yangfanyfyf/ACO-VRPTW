%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 解码
%输入：route_k             蚂蚁k的路径记录数组
%输入：cap                 最大载重量
%输入：demands             需求量
%输入：a                   顾客时间窗开始时间[a[i],b[i]]
%输入：b                   顾客时间窗结束时间[a[i],b[i]]
%输入：L                   配送中心时间窗结束时间
%输入：s                   客户点的服务时间
%输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j]=dist[i][j]
%输出：VC                  每辆车所经过的顾客，是一个cell数组
%输出：NV                  车辆使用数目
%输出：TD                  车辆行驶总距离
%
%思路：例子：当前个体编码为53214，
%那么首先从头开始遍历，第一条路径为5，然后依次将3添加到这条路径，
%则该条路径变为53，此时要检验53这条路径是否满足时间窗约束和载重量约束，
%如不满足其中任何一个约束，则需要新建路径，则3为一个顾客，然后按照这种方法添加。
%如果满足上述两个约束，则继续将2添加到53这条路径，然后继续检验532这条路径是否满足时间窗约束和载重量约束，
%依此类推。
function [VC,NV,TD] = decode(route_k,cap,demands,a,b,L,s,dist)
  route_k(route_k==0) = [];                             %将0从蚂蚁k的路径记录数组中删除
  cusnum = size(route_k,2);                             %已服务的顾客数目
  VC = cell(cusnum,1);                                  %每辆车所经过的顾客
  count = 1;                                            %车辆计数器，表示当前车辆使用数目
  preroute = [];                                        %存放某一条路径
  for i = 1:cusnum
      preroute = [preroute, route_k(i)];                 %将第route_k(i)添加到路径中
      % check the time window for the preroute
      % if meet, add point, if not, add a new route
      flag = JudgeRoute(preroute,cap,demands,a,b,L,s,dist);%判断当前路径是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
      if flag == 1 
          %如果满足约束，则更新车辆配送方案VC
          VC{count} = preroute;               
      else
          %如果不满足约束，则清空preroute，并使count加1
          preroute = route_k(i);     
          % add a new route
          count = count + 1;
          VC{count} = preroute;     
      end
  end
  [VC,NV] = CleanVehiclesCustomer(VC);                     %将VC中空的数组移除
  TD = TravelDistance(VC,dist);
end