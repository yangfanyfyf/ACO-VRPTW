% check the time window 
% flag == 0 means violated
function flag = Check(VC,a,b,L,s,dist)
    flag = 1; % assume the requirements are met 
    NV = size(VC,1); 
    % calculate the begin of service and the time back to the depot
    bsv = cell(NV, 1);
    for i = 1 : NV  
        route = VC{i};
        [~, bs, ~, back] = BeginService(route, a, s, dist);
        bsv{i} = [bs, back];
    end
    % check all routes
    violate_TW = CheckTW(VC,bsv,b,L);
    for i = 1:NV
        find1 = find(violate_TW{i}==1,1,'first'); 
        if ~isempty(find1)
            flag = 0;
            break
        end
    end
end