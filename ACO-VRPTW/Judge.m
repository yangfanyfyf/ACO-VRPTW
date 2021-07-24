%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 判断当前方案是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
%输入：chrom               个体
%输入：cap                 最大载重量
%输入：demands             需求量
%输入：a                   顾客时间窗开始时间[a[i],b[i]]
%输入：b                   顾客时间窗结束时间[a[i],b[i]]
%输入：L                   配送中心时间窗结束时间
%输入：s                   客户点的服务时间
%输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j]=dist[i][j]
%输出：flag                0表示违反约束，1表示满足全部约束
function flag=Judge(VC,a,b,L,s,dist)
flag=1;                         %假设满足约束
NV=size(VC,1);                  %车辆使用数目
%% 计算每辆车的装载量
% init_v=vehicle_load(VC,demands);
%% 计算每辆车配送路线上在各个点开始服务的时间，还计算返回集配中心时间
bsv = cell(NV, 1);
for i = 1 : NV  
    route = VC{i};
    [~, bs, ~, back] = begin_s(route, a, s, dist);
    bsv{i} = [bs, back];
end

%% 判断是否违背时间窗约束，0代表不违背，1代表违背
violate_INTW=Judge_TW(VC,bsv,b,L);
%% 遍历每条路径，一旦有一条路径不满足约束，flag=0
for i=1:NV
    find1=find(violate_INTW{i}==1,1,'first');      %寻找该条路径违反时间窗约束的顾客位置
    if ~isempty(find1)
        flag=0;
        break
    end
end
end

