# The Prelude: Statistics
Before getting into real statistical machine learning, I'll have to recap some basic statistics basic stuff... The main objective is to give a intuitive explanation of those basic concepts that are required in machine learning.

As we know, statistics has two branches, descriptive and inferential. The descriptive statistics is used to represent a bunch of data while inferential statistics uses data to make conclusion about things. Both of them are covered in statistical machine learning, and a large part of that is **probability theory**, where we are going to start.

## Random Process

### Random Variables
A variable is something whose value may change, but random variable seem to be a little bit tricky, because it can taken on a bunch of different values at the same time, and we can never solve it for its value. However, we can develop something to describe how does it work. 

A random variable can be treated as a map from a random process to a number, which is random. For example, we have a random variable which represents whether it rains tomorrow. It is 1 if it rains tomorrow, otherwise 0.

$$X=
\begin{cases}
    1 & \text{rain tomorrow} \\
    0 & \text{no rain}
\end{cases}
$$

In order to describe the behavior of random variable, we have a probability assigned to it

$$
P(X=x_1)
$$

The expression above indicates the probability for $X$ to have the value $x_1$. 

Random variables can be either discrete or continuous.

### Binomial Distribution
The core of Binomial Distribution is doing a series of random experiments, each of that has exactly two possible outcomes. For example, we are flipping a fair coin for $5$ times and let random variable $X$ represent the number of heads occurred after $5$ flips, so $X$ can be $0$, $1$, $2$, $3$, $4$, or $5$. We can calculate the probability for first three cases and the other 3 cases are symmetric.

$$
P(X=0) = (\frac{1}{2})^5
$$

$$
P(X=1) = {5 \choose 1}\times(\frac{1}{2})^5
$$

$$
P(X=2) = {5 \choose 2}\times(\frac{1}{2})^5
$$

This is quite intuitive, we have probability of $(\frac{1}{2})^5$ for each possible combination of 5 coins, and in order to calculate the probability of $k$ heads, we are actually choosing $k$ coins from $5$ and let them to be head.

Now let's make the problem a little bit complex. Suppose we have unfair coins, which has probability of $0.3$ to be head. In this case 

$$
P(X=0) = 0.3^5
$$

$$
P(X=1) = {6 \choose 1} \times 0.3 \times 0.7^4
$$

The calculation becomes
- Select $k$ fron $N$ to represent head
- multiply by probability of head to the power of $k$
- multiply by probability of tail to the power of $(N-k)$

The expectation of binomial distribution is 
$$
E(X) = np
$$

where $n$ is the number of experiments and $p$ is the probability of succeed one time. Let's prove that. We know that

$$
P(X=k) = {n \choose k}p^k(1-p)^{n-k}
$$

and the expection is the probabilistic weighted sum of outcomes

$$
\begin{aligned}
    E(X) & = \sum_{k=0}^{n}{n \choose k}p^k(1-p)^{n-k} \\
    & = \sum_{k=0}^n\frac{n!}{k!(n-k)!}p^k(1-p)^{n-k} \\
    & = \sum_{k=1}^n\frac{n(n-1)!}{(k-1)!(n-k)!}p\cdot p^{k-1} (1-p)^{n-k} \\
    & = np \cdot \sum_{k=1}^{n}\frac{(n-1)!}{(k-1)!(n-k)!}p^{k-1} (1-p)^{n-k}
\end{aligned}

$$

The part after $np$ in the equation above is actually the sum of probability of getting $k-1$ successes in $n-1$ trials with probability of each trail to be $p$. The sum should be $1$, so expected value is $np$

### Poisson Process
You might find Poisson process quite tricky, just like I did, because the math teacher sucks. Think about this scenario, we want to look at *how many vehicles pass the crossroad in one hour*. So we have random variable $X = \#\text{cars pass in 1 h}$, and we have following assumptions
- Every hour is identical
- Hours are independent

How are we gonna solve this? Well, let's assume that this problem is bionomial, that is, we divide one hour into 60 minutes, and do one trial per minute, there can either be one car passing by or no car at all. So we have 

$$
E(X) = np = \lambda
$$
where $\lambda$ is the number of cars per 60 minutes. So for each minute, the probability of having a car passing by is $\frac{\lambda}{60}$, so using the conclusion from binomial distribution, we have

$$
P(X=k) = {60 \choose k}(\frac{\lambda}{60})^k(1-\frac{\lambda}{60})^{60-k}
$$

But the problem is that there might be multiple cars passing by in one minute, which means we need a finer grained approximation. Well, the idea is to divide one hour into more intervals (infinite intervals).

Before we get into that, let's look at couple of facts that is helpful later on.

<!-- \lim_{x\rightarrow\infty} -->

$$
\lim_{x\rightarrow\infty} (1+\frac{a}{x})^x = e^a
$$
It is quite straightforward to get this, simply let 
$$
\frac{x}{a} = n
$$
Then the equation becomes 
$$
\lim_{n\rightarrow\infty} ((1+\frac{1}{n})^n)^a = e^a
$$



$$
\frac{x!}{(x-k)!} = x(x-1)(x-2)...(x-k+1)
$$  

Our probability is written as

$$
\begin{aligned}
    P(X=k) & = \lim_{n\rightarrow\infty} {n\choose k}(\frac{\lambda}{n})^k(1-\frac{\lambda}{n})^{n-k} \\
    & = \lim_{n\rightarrow\infty} \frac{n!}{k!(n-k)!}(\frac{\lambda}{n})^k(1-\frac{\lambda}{n})^n(1-\frac{\lambda}{n})^{-k}\\

    &=\lim_{n\rightarrow\infty}\frac{1}{k!}n(n-1)...(n-k+1)e^{-\lambda}(\frac{\lambda}{n})^k \\
    &= \lim_{n\rightarrow\infty}\frac{1}{k!}\frac{\lambda^k(n^k + ...)}{n^k}e^{-\lambda}\\
    &= \frac{\lambda^k}{k!}e^{-\lambda }
\end{aligned}

$$

### Bernoulli Distribution
Bernoulli is a special case of Binomial distribution with one single trial. For example, we have a random variable $X$ which represents the result of flipping a coin, which can either be Head or Tail. 

$$
x = 
\begin{cases}
1 & Head\\
0 & Tail

\end{cases}
$$

Then the pdf of the distribution is simply 

$$
P(X) = p^k(1-p)^{1-k}
$$
where $k$ can either be $0$ or $1$.

### Frequentist Approach vs Bayesian Approach
The difference between frequentist and Bayesian approach is that the assumption of variation of data and parameter. The frequentist assumes that the parameters are fixed in a certain problem, for example, in flipping coin trial, the parameter $p$ which represents the probability of Head is always 0.5. The infrerences are done by applying mathematics to the fixed parameters directly.

While the bayesian approach assumes that the data is fixed and the parameters can vary. In the case of flipping a coin, the probability of having a Head may related to some priors, for example, the gravity, the angle of the coin... As long as these parameters are fixed, we will always have same result. The uncertainty is introduced by the initial condition.

### Bayes' rule
The Bayes' rule states the the posterior of parameter of a given distribution is given by
$$
P(\theta|x) = \frac{P(x|\theta)P(\theta)}{P(x)}
$$

where the $P(x|\theta)$ is the likelihood and $P(\theta)$ is the prior distribution. Because of the assumption of certainty of invarient data, the posterior is proportional to likelihood multiplied by the prior

$$
P(\theta|x) \propto P(\theta)P(x|\theta)
$$

This relationship is quite useful if we assume the prior to be uniformly distributed, because we can maximize the posterior by maximizing the likelihood.

### Likelihood isn't a distribution
The likelihood $P(x|\theta)$ can also be written as $L(\theta|x)$.
We can figure out that
$$
\int L(\theta|x) dx = 1
$$
but in bayesian approach, the data is fixed, and the parameters are variables. If we integrate the likelihood 
$$
\int P(x|\theta) d\theta
$$

we are actually summing up the probability of data given parameter for all possible parameters. If the $\theta$ is from $-\infty$ to $\infty$, the integral can potentially be $-\infty$ to $\infty$, which does not satisfy the property of a distribution.