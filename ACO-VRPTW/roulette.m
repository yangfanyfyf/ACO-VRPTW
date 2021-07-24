%
%      @作者：随心390
%      @微信公众号：优化算法交流地
%
%% 轮盘赌
%输入p_value：                 记录状态转移概率
%输出index：                   轮盘赌选择的序号
function index=roulette(p_value)
  if p_value~=0
      n=length(p_value);
      p=p_value./sum(p_value);        %求概率
      pp=cumsum(p);
      R=rand;                         %生成一个随机数
      for i=1:n
          if i==1
              if R<=pp(i)
                  index=1;
                  break
              end
          else
              if R>=pp(i-1) && R<=pp(i)
                  index=i;
                  break
              end
          end
      end
  else
      index=1;
  end
end