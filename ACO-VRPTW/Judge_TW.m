%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 判断是否违背时间窗约束，0代表不违背，1代表违背
%输入vehicles_customer：       每辆车所经过的顾客
%输入bsv：                     每辆车配送路线上在各个点开始服务的时间，还计算返回集配中心时间
%输入b：                       顾客时间窗结束时间[a[i],b[i]]
%输入L：                       集配中心时间窗结束时间
%输出violate_TW：              否违背时间窗约束的元胞数组
function violate_TW=Judge_TW(vehicles_customer,bsv,b,L)
NV=size(vehicles_customer,1);               %所用车辆数量
violate_TW=bsv;
for i=1:NV
    route=vehicles_customer{i};
    bs=bsv{i};
    l_bs=length(bsv{i});
    for j=1:l_bs-1
        if bs(j)<=b(route(j))
            violate_TW{i}(j)=0;
        else
            violate_TW{i}(j)=1;
        end
    end
    if bs(end)<=L
        violate_TW{i}(end)=0;
    else
        violate_TW{i}(end)=1;
    end
end
end