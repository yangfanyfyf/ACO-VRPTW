% 8 a.m to 18 p.m
% hour to min 
function time = TimeTrans(time_old)
    % 调整时间的格式
    v = 2; 
    time = (time_old - 8) * 60 * v;
end
