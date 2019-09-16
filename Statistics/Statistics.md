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

### Beta distribution
The probability distribution of beta distribution is simply given by

$$
Beta(a,b) = \frac{\theta^{a-1}(1-\theta)^{b-1}}{B(a,b)}
$$

$$
B(a,b) = \frac{\Gamma(a)\Gamma(b)}{\Gamma(a+b)}
$$

where $\theta$ is a random variable of which the value is from $0$ to $1$. The demoninator is a normalization function of $a$ and $b$ in order to make sure the integration of pdf over random variable is 1.

The following graph indicates different pdf shapes when $a$ and $b$ have different value combinations.


![](./img/beta.png)

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

we are actually summing up the probability of data given parameter for all possible parameters. If the $\theta$ is from $-\infty$ to $\infty$, the integral can potentially be $-\infty$ to $\infty$, which does not satisfy the property of a distribution. That's why we always say likelihood function instead of likelihood distribution.


### Conjugate Distribution
If prior and posterior distributions are of the same probability distribution family, and the prior is called the conjugate prior to the likelihood function. 

For example, Beta distribution is conjugate to Bernoulli/Binomial distribution. In order to understand this, we'll need to introduce the Gamma function. Gamma function is like factorial defined on Real numbers. For an non-negative integer $\alpha$, we have

$$
\Gamma(\alpha + 1) = \alpha!
$$

Therefore, we can write choose function into the form of Gamma function

$$
{N \choose x} = \frac{\Gamma(N+1)}{\Gamma(N-x+1)\Gamma(x+1)}
$$

Now we have a posterior distribution
$$
P(\theta|x) \propto P(x|\theta)P(\theta)
$$

where
$$
P(\theta) \sim Beta(a,b)
$$

From Binomial distribution, we have
$$P(x|\theta) \propto \theta^z(1-\theta)^{N-z}$$

and from Beta distribution we have 
$$P(\theta) \propto \theta^{a-1}(1-\theta)^{b-1}$$

let $a' = a + z$ and $b' = N+b-z$, we can simply get 

$$
P(\theta|x) \sim Beta(a', b')
$$


# Machine Learning Basics

## Regression as Probabilistic Model

Suppose that we have a linear model with Gaussian noise, given by

$$
Y =\bold{X'w} + \sigma
$$

$$
\sigma \sim \mathcal{N}(0, \sigma^2)
$$
with
$$
\mathcal{N}(x;\mu \sigma^2) = \frac{1}{\sqrt{2\pi\sigma^2}}exp(-\frac{(x-\mu)^2}{2\sigma^2})
$$

## Logistic Regression

## Perceptron Learning Algorithm

## Multi-layer perceptron and back propagation

## SVM and Kernel Method
Support vector machine is a binary classification tool. It takes a data point and output a value which is $1$ or $-1$.
What we wanna do with SVM is that we wanna find the support vectors that are closest data instances to the hyperplain that divide the dataset, and find such a hyperplain that maximize the distance.


### Hard margin SVM

Suppose if we have a data point $X$, the distance between the point and the hyper plain $P:y = w'x + b$ is calculated as follows:
- We find a vector $r$, which is $X + r = X_p$, where $X_p$ is a point on the hyper plain and $r\perp P$
- It is obvious that $r$ is parallel to $w$
- The magnitude of $r$ is given by $r=w\frac{||r||}{||w||}$
- We have $X + w\frac{||r||}{||w||} = X_p$
- Multiply $w$ on both sides and add $b$, and we know $X_p$ is on hyper plain, so we finally get $||r|| = \plusmn \frac{w'x + b}{||w||}$
- Because the $y$ is either $-1$ or $1$, we get $||r|| = \frac{y_i(w'x + b)}{||w||}$

The SVM maxinizes the magnitude of $r$

$\max \frac{y_i(w'x + b)}{||w||}, i=1,2,...n$

The problem is that there might be infinity possible values for $w$ and $b$ which are $\alpha w$ and $\alpha b$ where $\alpha>0$. In order to resolve the ambiguity, we have following constraints

$$\frac{y_{i*}(w'x_{i*} + b)}{||w||} = \frac{1}{||w||}$$
where $*$ denotess the closest data point to the hyper-plain. Than the objective becomes 
$$
\argmin_{w,b} ||w|| \\
s.t. \text{  } y_i(w'x + b) \geq 1
$$

### Training hard margin SVM
To train the hard margin SVM, we need to apply Lagrangian Duality. The canonical form of it is show as following

$$
\argmin f(x) \\
s.t \text{ } g(x) \leq 0,\\
h(x) = 0
$$ 

And we have following exoression introducing some auxilliary variable $\lambda$ and $\nu$

$$
L(x, \lambda, \nu) = f(x) + \sum \lambda_i g_i(x) + \sum \nu_j h_j(x) 
$$

For hard margin SVM, the lagrange multiplier is shown as follows

$$
L = \frac{1}{2}||w||^2 - \sum \lambda (y(w'x + b) - 1)
$$

We have $\frac{\delta L}{\delta b} = \sum \lambda y = 0$ and $\frac{\delta L}{\delta w} = w - \sum_i\lambda_iy_ix_i = 0$

Substituting into the original expression, we get 
$$
L' = \sum_i\lambda_i - \frac{1}{2}\sum_i\sum_j \lambda_i\lambda_jy_iy_jx_ix_j
$$
Where the $L'$ is the dual problem of prime problem. In order to predict, just calculate the sing
$$
s = b + \sum \lambda_iy_ix_ix_j
$$
where $x_j$ is the point to predict.