% find out the possible next points for ants, consider the tw constraints

function Nik = NextPointSet(k,Table,a,b,L,s,dist)
  route_k = Table(k,:); %route of ant K
  cusnum = size(Table,2); % customer in this route
  route_k(route_k == 0) = []; % delete zeros
  
  if ~isempty(route_k)
      [VC,~,~] = decode(route_k,a,b,L,s,dist); % all routes of ant k
      route = VC{end,1}; % the route in contruction
      lr = length(route);
      preroute = zeros(1,lr+1); % save the possible route
      preroute(1:lr) = route;
      allSet = 1:cusnum;
      unVisit = setxor(route_k,allSet); % setxor return the elements which are not in the intersection
      uvNum = length(unVisit);
      Nik = zeros(uvNum,1); % points not in k
      for i = 1:uvNum
          % add points to the route and then check the constraints
          preroute(end) = unVisit(i); 
          flag = JudgeRoute(preroute,a,b,L,s,dist);
          % if meet the constraints, add it to the Nik
          if flag == 1
              Nik(i) = unVisit(i);
          end
      end
      Nik(Nik == 0) = []; % delete zeros
  else
      % if the ant has not visited any customer
      Nik=1:cusnum;
  end
end
  
