%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 检查最优解中是否存在元素丢失的情况
%输入op_fvc       最有分配方案
%输出DEL          丢失元素，如果没有则为空
function DEL=Judge_Del(op_fvc)
NV=size(op_fvc,1);
route=[];
for i=1:NV
    route=[route op_fvc{i}];
end
sr=sort(route);
LEN=length(sr);
%% 寻找丢失的元素
INIT=1:100;
%setxor(a,b)可以得到a,b两个矩阵不相同的元素，也叫不在交集中的元素
DEL=setxor(sr,INIT);
end

