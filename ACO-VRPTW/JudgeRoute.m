% check the time windows in a route
function flag = JudgeRoute(route, a, b, L, s, dist)
    flag = 1; % assume the constrains are meet
    lr = length(route);
    [arr, bs, wait, back] = BeginService(route, a, s, dist);
    if back <= L % meet the time window at depot
        for i = 1 : lr % check the customers
            if bs(i) > b(route(i))
                flag = 0;
            end
        end
    else
        flag = 0;
    end
end