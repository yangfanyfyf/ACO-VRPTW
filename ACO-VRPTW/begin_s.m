% calculate :
% arr, arrival time 
% bs, begin service time
% wait, time to wait
% back, time back to depot
function [arr,bs,wait,back] = begin_s(route,a,s,dist)
  n = length(route); 
  arr = zeros(1,n); 
  bs = zeros(1,n); 
  wait = zeros(1,n);  
  arr(1) = dist(1,route(1)+1); % the dist between the depot and the first customer,
  bs(1) = max(a(route(1)),dist(1,route(1)+1));
  wait(1) = bs(1)-arr(1);
  for i = 1:n
      if i ~= 1
          % arrival time = begin time of (i - 1) + service time of (i - 1) + distance between i - 1 and i
          arr(i) = bs(i-1) + s(route(i-1)) + dist(route(i-1)+1,route(i)+1);
          % if the arrival time is earlier, then the start time is the left time window
          bs(i) = max(a(route(i)), arr(i));
          wait(i) = bs(i) - arr(i);
      end
  end
  % back to the depot
  back = bs(end) + s(route(end)) + dist(route(end)+1,1);
  end