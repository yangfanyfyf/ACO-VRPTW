tic
iter = 0;
iter_max = 10;
while iter <= iter_max
    
    if rand > 0.8
        break;
    end
    iter = iter + 1;
end
%iter = floor(rand * 100);
toc