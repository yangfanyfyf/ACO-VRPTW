% delete the empty arrays in vehicles_customer
% input: vehicles_customer, a cell stores all routes
% output: final_vehicles_customer, the route without empty array
%         vehicle_used, number of vehicles/ routes
function [final_vehicles_customer,vehicles_used] = CleanVehiclesCustomer(vehicles_customer)
    vecnum = size(vehicles_customer,1); 
    final_vehicles_customer = {};
    count = 1;
    for i = 1 : vecnum
        par_seq = vehicles_customer{i}; % the i-th route 
        % the route is not empty, add to final_vehicles_customer
        if ~isempty(par_seq)                        
            final_vehicles_customer{count} = par_seq;
            count = count+1;
        end
    end
    final_vehicles_customer = final_vehicles_customer';       
    vehicles_used = size(final_vehicles_customer,1); % number of customers 
end
