% run main.m for 100 times 
% 
num_cal = 100;
num_iter = zeros(num_cal,1);
aver_iter_time = zeros(num_cal, 1);
single_iter_time = cell(num_cal,1);
main_time = zeros(num_cal, 1);
time = 1;
while time <= num_cal 
    main_start = tic;
    main;
    main_time(time) = toc(main_start);
    % if the value is wrong, should I spring it?
    if iter > iter_max
        num_iter(time) = iter - 1;
    else
        num_iter(time) = iter - 31;
    end
    iter_time(iter_time == 0) = [];
    single_iter_time(time) = {iter_time};
    aver_iter_time(time) = mean(iter_time);
    time = time + 1;
end


save('test.mat')

histogram(num_iter);
disp('Number of Iterations: ');
disp(['Average: ',num2str(mean(num_iter)), ', Standard Deviation: ', num2str(std(num_iter))]);
fprintf('\n')

disp('Time of Iterations: ');
disp(['Average Single Iteration Time: ', num2str(mean(aver_iter_time))])
fprintf('\n')

disp('Time of Complete Calculations: ');
disp(['Average Calculation Time: ', num2str(mean(main_time))])