% roulette wheel selection
% input p_value is a vector
function index = Roulette(p_value)
  if p_value ~= 0
      n = length(p_value);
      p = p_value ./ sum(p_value); % convert to probability
      pp = cumsum(p); % cumulative sum
      R = rand; % generate a random value
      for i = 1:n
          if i == 1
              if R <= pp(i)
                  index = 1;
                  break
              end
          else
              % find the range of R
              if R>=pp(i-1) && R<=pp(i)
                  index = i;
                  break
              end
          end
      end
  else
      index=1;
  end
end