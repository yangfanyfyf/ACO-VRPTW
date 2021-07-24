%当前个体编码为53214，
%那么首先从头开始遍历，第一条路径为5，然后依次将3添加到这条路径，
%则该条路径变为53，此时要检验53这条路径是否满足时间窗约束和载重量约束，
%如不满足其中任何一个约束，则需要新建路径，则3为一个顾客，然后按照这种方法添加。
%如果满足上述两个约束，则继续将2添加到53这条路径，然后继续检验532这条路径是否满足时间窗约束和载重量约束，
%依此类推。
function [VC,NV,TD] = decode(route_k,a,b,L,s,dist)
  route_k(route_k==0) = [];                             %将0从蚂蚁k的路径记录数组中删除
  cusnum = size(route_k,2);                             %已服务的顾客数目
  VC = cell(cusnum,1);                                  %每辆车所经过的顾客
  count = 1;                                            %车辆计数器，表示当前车辆使用数目
  preroute = [];                                        %存放某一条路径
  for i = 1:cusnum
      preroute = [preroute, route_k(i)];                 %将第route_k(i)添加到路径中
      % check the time window for the preroute
      % if meet, add point, if not, add a new route
      flag = JudgeRoute(preroute,a,b,L,s,dist);%判断当前路径是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
      if flag == 1 
          % meet the constraints, update the route 
          VC{count} = preroute;               
      else
          % violated, build a new route
          preroute = route_k(i);     
          % add a new route
          count = count + 1;
          VC{count} = preroute;     
      end
  end
  [VC,NV] = CleanVehiclesCustomer(VC); % remove the empty route
  TD = TravelDistance(VC,dist);
end