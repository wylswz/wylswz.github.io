# AI Planning for Autonomy

## Search

### Search algorithms
- BrFS: Use queue, layer by layer
- ID: Iteratively increase depth of depth-first search
- DFS: Use stack
- Best First Search: Only consider heuristic
- Dijkstra: Only consider cost
- A*: Cost + Heuristic using priority queue
- Hill climbing

### Heuristic
- Admissible: Optimal solution with reopening
- Admissible and consistent: Optimal solution without reopening
- Admissible + goal-aware -> Consistent

### Exploration vs Exploitation
- UCTS 
  $$a = argmax_aQ(s,a) + 2 \sqrt{\frac{2\ln N(s)}{N(s,a)}}$$


## Tao Lu

### Iterative Deepening

### A*

- Init priority queue using cost + huristic
- Add init state
- Keep dequeueing and expand node until find goal


### STRIPES Modeling

P = <F, O, I, G>


### Bellman-Ford
- Init a table with first row
    - any state which is in init state are initialized to 0 otherwise  $\infty$
- go row by row, update the values with the minimum of 
    - val on last row
    - pre condition value + cost. If more than one precondition, take max or sum depending on you are calculating $h^{max}$ or $h^{add}$
- Repeat until no cell changes from last row.
- Calculat $h^{add}$ or $h^{max}$ by taking sum  or max of goal state atoms from last row.



### Best support

- Backtrack from the goal, choost actions that minimize cost(including the cost to reach its pre ), open nodes, and repeat until open becomes empty. 
  - If $h^{max}$, take the maximum of precondition heuristics and add the cost of action to current state
  - If $h^{add}$, take the sum of precondition heuristics and add the cost of action to current state 
- Summing up costs of actions to get $h^{FF}$




### IW

$IW(k)$ means performing breadth-first search and prune newly generated states with novelty > k. Iteratively increase k until problem solved or reach limit.

- Perform node expanding same as BFS
- Calculate novelty, prune of it's larger than k


### MDP
When MDP is known, we can use value iteration or policy iteration to work out the optimal policy

### Value Iteration
- Given $\gamma$
- $V_{i+1}(s) = max_{a}\sum P(s'\|s)[r(s,a,s') + \gamma V_i(s')]$
    - For each action, calculate the reward for next iteration
    - Select the highest reward


### Policy Iteration
- **init policy**
- **Policy Evaluation:** Calculate $V^\pi (s)$ for all action at all states using 
  $$V^\pi(s) = \sum P(s'|s)[r(s',a,s) + \gamma V^\pi(s')]$$
- **Policy Improvement:** Update the policy table for each state by $\pi(s) = argmax_{a\in A(s)}Q_\pi (a,s)$
- If changed, re-evaluate again

### Reinforcement Learning
Reinforcement learning is used when the model of problem is unknown to us.

- **Q Learning:** 

    $$Q(s,a) = Q(s,a) + \lambda [r + \gamma\cdot max_{a'}Q(s',a') - Q(s,a)]$$

- **SARSA:**
    $$Q(s,a) = Q(s,a) + \lambda [r + \gamma \cdot Q(s',a') - Q(s,a)]$$

Q-Learning differs from SARSA that it has the assumption that the next state is taking optimal action, but in fact it does not necessarily (agent may need to explore, thus non-optimal action is taken). While SARSA uses the Q of next step the update the current Q, which means if the agent take non-optimal action at $s'$, this will affect updating Q value at the current state. Therefore if $\epsilon$-greedy is used, SARSA tend to train a more conservative policy instead of aggresive one.

- N-Step SARSA
  replace original $r + \gamma Q$ with
  $$r1 + \gamma r_2 + ... + \gamma^{n-1}r_n + \gamma^{n}Q$$

  Where all the rs and Qs are given in the problem statement


