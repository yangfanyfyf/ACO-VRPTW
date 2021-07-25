% calculate the travel distances (all routes and each routes) 
function [sumTD, everyTD] = TravelDistance(vehicles_customer, dist)
    n = size(vehicles_customer,1);
    everyTD = zeros(n,1); % save the length of each path
    for i = 1:n
        part_seq = vehicles_customer{i}; % the i-th route
        if ~isempty(part_seq)
            everyTD(i) = PartLength(part_seq,dist); % the distance for every route
        end
    end
    sumTD = sum(everyTD); % all routes
end  