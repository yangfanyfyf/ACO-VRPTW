% cal the route length
function part_length = PartLength(route, dist)
    n = length(route);
    part_length = 0;
    if n ~= 0
        for i = 1 : n
            if i == 1
                part_length = part_length + dist(1, route(i) + 1);
            else
                part_length = part_length + dist(route(i-1) + 1, route(i) + 1);
            end
        end
        part_length = part_length + dist(route(end) + 1, 1);
    end
end