# ACO-VRPTW

```matlab
Procedure ACO
	Initialization
	while(termination conditions not meet):
		ConstructAntSolutions
		ApplyLocalSearch %optional
		UpdatePheromone
	end
end
```

### Initialization

Set all parameters

### ConstructAntSolutions

Each ant starts with an initially empty solution and the current partial solution will be extended by choosing one feasible solution component with the following rules:

1. Prefer the customer with small waiting time(wait = left time window - arrival time), because we don't want the customer to wait for a long time
2. Prefer the customer with a small width of time window (width = right time window - left time window)
3. If the random value $r$ Is smaller than $r_0$, choose the next point $j$ which has the biggest value of $[\tau_{ij}]^\alpha [\eta_{ij}]^\beta [1/width_j]^\gamma [1/wait_j]^\delta$​​ 
4. Otherwise, use roulette wheel selection and the $P_{ij}^k$ to choose next point $j$​​ 


$$
j = 
	\begin{cases}
		arg\ max_{j \in N_i^k} \lbrace [\tau_{ij}]^\alpha [\eta_{ij}]^\beta [1/width_j]^\gamma [1/wait_j]^\delta \rbrace & \text{$r\leq r_0$} \\[2ex]
		P_{ij}^k = \frac
		{[\tau_{ij}]^\alpha [\eta_{ij}]^\beta [1/width_j]^\gamma [1/wait_j]^\delta}
		{\sum_{l\in N_i^k}[\tau_{il}]^\alpha [\eta_{il}]^\beta [1/width_l]^\gamma [1/wait_l]^\delta} & \text{$r > r_0$}
	\end{cases}
$$

Parameters $\alpha, \beta, \gamma, \delta$​​ determine the influence of the corresponding component.

$\tau$​ , pheromone 

$\eta$​ , the heuristic information, is equal to the inverse value of distance

$r$​ , a random value

$r_0$ , a constant

### UpdatePheromone

Only update the pheromone on the edge with the best route
$$
\tau_{ij}^{new} = \rho * \tau_{ij}^{old} + \Delta \tau_{ij}\\
\Delta \tau_{ij} = \frac {Q}{TD}
$$
$Q$​ , a constant

$TD$ , the total distance

