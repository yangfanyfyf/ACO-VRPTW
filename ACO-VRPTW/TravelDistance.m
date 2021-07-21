%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 计算每辆车所行驶的距离，以及所有车行驶的总距离
%输入vehicles_customer   每辆车所经过的顾客
%输入dist                距离矩阵
%输出sumTD               所有车行驶的总距离
%输出everyTD             每辆车所行驶的距离
function [sumTD, everyTD] = TravelDistance(vehicles_customer, dist)
    n = size(vehicles_customer,1);                        %车辆数
    everyTD = zeros(n,1); % save the length of each path
    for i = 1:n
        part_seq = vehicles_customer{i};                  %每辆车所经过的顾客
        %如果车辆不经过顾客，则该车辆所行使的距离为0
        if ~isempty(part_seq)
            everyTD(i) = part_length(part_seq,dist);
        end
    end
    sumTD = sum(everyTD);                                 %所有车行驶的总距离
end  