% convert the numbers to routes
% e.g. if route_k == 53421
% a suitable route is 5->3
% then next check the constraints of 5->3->4
% if this route violates the constraints, then remove 4, and use 4 to build
% a new route
function [VC,NV,TD] = decode(route_k,a,b,L,s,dist)
  route_k(route_k==0) = [];
  cusnum = size(route_k,2);
  VC = cell(cusnum,1);
  count = 1;
  preroute = [];
  for i = 1:cusnum
      preroute = [preroute, route_k(i)];                 %将第route_k(i)添加到路径中
      % check the time window constraints for the preroute
      % if meet, add point, if not, add a new route
      flag = JudgeRoute(preroute,a,b,L,s,dist);
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