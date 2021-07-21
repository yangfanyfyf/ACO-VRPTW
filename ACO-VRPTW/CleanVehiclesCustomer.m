%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 根据vehicles_customer整理出final_vehicles_customer，将vehicles_customer中空的数组移除
%输入：vehicles_customer        每辆车所经过的顾客
%输出：final_vehicles_customer  删除空数组，整理后的vehicles_customer
% input: vehicles_customer, a cell stores all routes
% output: final_vehicles_customer, the route without empty array
%         vehicle_used, number of vehicles/ routes
function [final_vehicles_customer,vehicles_used] = CleanVehiclesCustomer(vehicles_customer)
    vecnum = size(vehicles_customer,1);               %车辆数
    final_vehicles_customer = {};                     %整理后的vehicles_customer
    count = 1;                                        %计数器
    for i = 1 : vecnum
        par_seq = vehicles_customer{i};               %每辆车所经过的顾客
        % the route is not empty, add to final_vehicles_customer
        if ~isempty(par_seq)                        
            final_vehicles_customer{count} = par_seq;
            count = count+1;
        end
    end
    %% 为了容易看，将上述生成的1行多列的final_vehicles_customer转置了，变成多行1列的了
    final_vehicles_customer = final_vehicles_customer';       
    vehicles_used = size(final_vehicles_customer,1);              %所使用的车辆数
end
