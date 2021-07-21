%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
% 计算一个子回路的路径长度
% function p_l= part_length(route,dist)
%   n=length(route);
%   p_l=0;
%   if n~=0
%       for i=1:n
%           if i==1
%               p_l=p_l+dist(1,route(i)+1);
%           else
%               p_l=p_l+dist(route(i-1)+1,route(i)+1);
%           end
%       end
%       p_l=p_l+dist(route(end)+1,1);
%   end
% end




function part_length = PartLength(route, dist)
    n = length(route);
    part_length = 0;
    if n ~= 0
        for i = 1 : n
            if i = 1
                part_length = part_length + dist(1, route(i) + 1);
            else
                part_length = part_length + dist(route(i) + 1, route(i) + 1);
            end
        end
        part_length = part_length + dist(route(end) + 1, 1);
    end
end