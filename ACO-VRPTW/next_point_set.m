%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 找到蚂蚁k从i点出发可以移动到的下一个点j的集合，j点必须是满足容量及时间约束且是未被蚂蚁k服务过的顾客
%输入k：                   蚂蚁序号
%输入Table：               路径记录表
%输入cap：                 最大载重量
%输入demands：             需求量
%输入a：                   顾客时间窗开始时间[a[i],b[i]]
%输入b：                   顾客时间窗结束时间[a[i],b[i]]
%输入L：                   配送中心时间窗结束时间
%输入s：                   客户点的服务时间
%输入dist：                距离矩阵
%输出Nik：                 蚂蚁k从i点出发可以移动到的下一个点j的集合，j点必须是满足容量及时间约束且是未被蚂蚁k服务过的顾客
function Nik=next_point_set(k,Table,cap,demands,a,b,L,s,dist)
  route_k = Table(k,:);                                     %蚂蚁k的路径
  cusnum = size(Table,2);                                   %顾客数目
  route_k(route_k == 0) = [];                                 %将0从蚂蚁k的路径记录数组中删除
  %% 如果蚂蚁k已经访问了若干个顾客
  if ~isempty(route_k)
      [VC,NV,TD]=decode(route_k,cap,demands,a,b,L,s,dist);    %蚂蚁k目前为止所构建出的所有路径
      route = VC{end,1};                                        %蚂蚁k当前正在构建的路径
      lr = length(route);                                       %蚂蚁k当前正在构建的路径所访问顾客数目
      preroute = zeros(1,lr+1);                                 %临时变量，储存蚂蚁k当前正在构建的路径添加下一个点后的路径
      preroute(1:lr) = route;
      allSet = 1:cusnum;                                        %setxor(a,b)可以得到a,b两个矩阵不相同的元素，也叫不在交集中的元素，
      unVisit = setxor(route_k,allSet);                         %找出蚂蚁k未服务的顾客集合
      uvNum = length(unVisit);                                  %找出蚂蚁k未服务的顾客数目
      Nik=zeros(uvNum,1);                                     %初始化蚂蚁k从i点出发可以移动到的下一个点j的集合，j点必须是满足容量及时间约束且是未被蚂蚁k服务过的顾客
      for i=1:uvNum
          preroute(end)=unVisit(i);                           %将unVisit(i)添加到蚂蚁k当前正在构建的路径route后
          flag=JudgeRoute(preroute,cap,demands,a,b,L,s,dist); %判断当前路径是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
          %如果满足约束，则将unVisit(i)添加到蚂蚁k从i点出发可以移动到的下一个点j的集合中
          if flag==1
              Nik(i)=unVisit(i);
          end
      end
      Nik(Nik==0)=[];                                         %将0从np_set中删除
  else
      %% 如果蚂蚁k没有访问任何顾客
      Nik=1:cusnum;                                           %则所有顾客都可以成为候选点
  end
  end