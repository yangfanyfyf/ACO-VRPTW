% find the next point for the ants

function point_j =  next_point_temp(k, Table, Tau, Eta, alpha, beta, gamma, delta, r, r0, a, b, width, s, L, dist)
  route_k = Table(k, :);
  % find the last point i in route k
  point_i = route_k(find(route_k ~= 0, 1, 'last'));
  if isempty(point_i)
    point_i = 0;
  end
  route_k(route_k == 0) = []; % remove the depot
  cusnum = size(Table, 2);
  allSet = 1 : cusnum;
  unVisit = setxor(route_k, allSet);
  uvNum = length(unVisit);
  [VC, NV, TD] = decode(route_k, a, b, L, s, dist);
  if ~isempty(VC)
    % the last route is still in build.
    route = VC{end, 1};
  else
    route = [];
  end
  lr = length(route);
  preroute = zeros(1, lr + 1);
  preroute(1:lr) = route;
  % find the possible next point, must fullfill the time window constraints
  Nik = next_point_set(k, Table, a, b, L, s, dist);

  % situation 1
  % calculate p_value for every possble point, choose the point with the maximum p_value
  if r <= r0
    if ~isempty(Nik)
      Nik_num = length(Nik);
      p_value = zeros(Nik_num, 1);
      for h = 1 : Nik_num
        % for every possible route
        point_j = Nik(h);
        preroute(end) = point_j;
        [~, ~, wait, ~] = begin_s(preroute, a, s, dist);
        if wait(end) == 0
          wait(end) = 1e-8;
        end
        p_value(h, 1) = ((Tau(point_i+1, point_j+1)^alpha)) * ...
                        ((Eta(point_i+1, point_j+1)^beta)) * ...
                        ((1/width(point_j))^gamma) * ...
                        ((1/wait(end))^delta);
      end
      [~, maxIndex] = max(p_value);
      point_j = Nik(maxIndex);
    else
      % if there is no suitable next point, choose point in the unvisited point and start a new route. 
      p_value = zeros(uvNum, 1);
      for h = 1 : uvNum
        point_j = unVisit(h);
        preroute(end) = point_j;
        [~, ~, wait, ~] = begin_s(preroute, a, s, dist);
        if wait(end) == 0
          wait(end) = 1e-8;
        end
        p_value(h, 1) = ((Tau(point_i+1, point_j+1)^alpha)) * ...
                        ((Eta(point_i+1, point_j+1)^beta)) * ...
                        ((1/width(point_j))^gamma) * ...
                        ((1/wait(end))^delta);
      end
      [~, maxIndex] = max(p_value);
      point_j = unVisit(maxIndex);
    end
  else
    % situation 2
    % r > r0
    if ~isempty(Nik)
      Nik_num = length(Nik);
      p_value = zeros(Nik_num, 1);
      for h = 1 : Nik_num
        point_j = Nik(h);
        preroute(end) = point_j;
        [~, ~, wait, ~] = begin_s(preroute, a, s, dist);
        if wait(end) == 0
          wait(end) = 1e-8;
        end
        p_value(h, 1) = ((Tau(point_i+1, point_j+1)^alpha)) * ...
                        ((Eta(point_i+1, point_j+1)^beta)) * ...
                        ((1/width(point_j))^gamma) * ...
                        ((1/wait(end))^delta);
      end
      index = roulette(p_value);
      point_j = Nik(index);
    else
      p_value = zeros(uvNum, 1);
      for h = 1 : uvNum
        point_j = unVisit(h);
        preroute(end) = point_j;
        [~, ~, wait, ~] = begin_s(preroute, a, s, dist);
        if wait(end) == 0
          wait(end) = 1e-8;
        end
        p_value(h, 1) = ((Tau(point_i+1, point_j+1)^alpha)) * ...
                        ((Eta(point_i+1, point_j+1)^beta)) * ...
                        ((1/width(point_j))^gamma) * ...
                        ((1/wait(end))^delta);
      end
      index = roulette(p_value);
      point_j = unVisit(index);
    end
end