%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 根据转移公式，找到蚂蚁k从i点出发移动到的下一个点j，j点必须是满足容量及时间约束且是未被蚂蚁k服务过的顾客

function j=next_point(k,Table,Tau,Eta,alpha,beta,gama,delta,r,r0,a,b,width,s,L,dist)
  route_k = Table(k,:);                                         %蚂蚁k的路径, table store the routes
  i = route_k(find(route_k ~= 0, 1, 'last'));                       %蚂蚁k正在访问的顾客编号, return the last one index
  if isempty(i) % not find, in the depot
      i = 0; 
  end
  route_k(route_k==0)=[];                                     %将0从蚂蚁k的路径记录数组中删除 % 为什么要删除0
  cusnum = size(Table,2);                                       %顾客数目
  allSet = 1:cusnum;                                            %setxor(a,b)可以得到a,b两个矩阵不相同的元素，也叫不在交集中的元素，
  unVisit = setxor(route_k,allSet);                             %找出蚂蚁k未服务的顾客集合
  uvNum=length(unVisit);                                      %找出蚂蚁k未服务的顾客数目
  [VC,NV,TD] = decode(route_k,a,b,L,s,dist);        %蚂蚁k目前为止所构建出的所有路径
  %如果当前路径配送方案不为空
  if ~isempty(VC) % route exist
      route = VC{end,1};                                            %蚂蚁k当前正在构建的路径
  else
      %如果当前路径配送方案为空
      route = [];
  end
  lr=length(route);                                           % numbers os cuntomers for ant K
  preroute=zeros(1,lr+1);                                     % 临时变量，储存蚂蚁k当前正在构建的路径添加下一个点后的路径
  preroute(1:lr)=route;
  Nik=next_point_set(k,Table,a,b,L,s,dist);       %找到蚂蚁k从i点出发可以移动到的下一个点j的集合，j点必须是满足容量及时间约束且是未被蚂蚁k服务过的顾客
  
  %% 如果r<=r0，j=max{[Tau(i,j)]^alpha * [Eta(i+1,j+1)]^beta * [1/width(j)]^gama * [1/wait(j)]^delta}
  if r<=r0
      %如果Nik非空，即蚂蚁k可以在当前路径从顾客i继续访问顾客
      if ~isempty(Nik)
          Nik_num=length(Nik);
          p_value=zeros(Nik_num,1);                           %记录状态转移概率
          for h=1:Nik_num
              j=Nik(h);
              preroute(end)=j;
              [~,~,wait,~]=begin_s(preroute,a,s,dist);
              if wait(end)==0
                  wait(end)=1e-8;
              end
              p_value(h,1)=((Tau(i+1,j+1))^alpha)*((Eta(i+1,j+1))^beta)*((1/width(j))^gama)*((1/wait(end))^delta);
          end
          [~,maxIndex]=max(p_value);                          %找出p_value中最大值所在序号
          j=Nik(maxIndex);                                    %确定顾客j
      else
          %如果Nik为空，即蚂蚁k必须返回配送中心，从配送中心开始访问新的顾客
          p_value=zeros(uvNum,1);                             %记录状态转移概率
          for h=1:uvNum
              j=unVisit(h);
              preroute(end)=j;
              [~,~,wait,~]=begin_s(preroute,a,s,dist);
              if wait(end)==0
                  wait(end)=1e-8;
              end
              p_value(h,1)=((Tau(i+1,j+1))^alpha)*((Eta(i+1,j+1))^beta)*((1/width(j))^gama)*((1/wait(end))^delta);
          end
          [~,maxIndex]=max(p_value);                          %找出p_value中最大值所在序号
          j=unVisit(maxIndex);                                %确定顾客j
      end
  else
      %% 如果r>r0，依据概率公式用轮盘赌法选择点j
      %如果Nik非空，即蚂蚁k可以在当前路径从顾客i继续访问顾客
      if ~isempty(Nik)
          Nik_num=length(Nik);
          p_value=zeros(Nik_num,1);                           %记录状态转移概率
          for h=1:Nik_num
              j=Nik(h);
              preroute(end)=j;
              [~,~,wait,~]=begin_s(preroute,a,s,dist);
              if wait(end)==0
                  wait(end)=1e-8;
              end
              p_value(h,1)=((Tau(i+1,j+1))^alpha)*((Eta(i+1,j+1))^beta)*((1/width(j))^gama)*((1/wait(end))^delta);
          end
          index=roulette(p_value);                            %根据轮盘赌选出序号
          j=Nik(index);                                       %确定顾客j
      else
          %如果Nik为空，即蚂蚁k必须返回配送中心，从配送中心开始访问新的顾客
          p_value=zeros(uvNum,1);                             %记录状态转移概率
          for h=1:uvNum
              j=unVisit(h);
              preroute(end)=j;
              [~,~,wait,~]=begin_s(preroute,a,s,dist);
              if wait(end)==0
                  wait(end)=1e-8;
              end
              p_value(h,1)=((Tau(i+1,j+1))^alpha)*((Eta(i+1,j+1))^beta)*((1/width(j))^gama)*((1/wait(end))^delta);
          end
          index=roulette(p_value);                            %根据轮盘赌选出序号
          j=unVisit(index);                                   %确定顾客j
      end
  end
  end