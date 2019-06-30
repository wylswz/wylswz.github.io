# The Prelude: Statistics
Before getting into real statistical machine learning, I'll have to recap some basic statistics basic stuff... The main objective is to give a intuitive explanation of those basic concepts that are required in machine learning.

As we know, statistics has two branches, descriptive and inferential. The descriptive statistics is used to represent a bunch of data while inferential statistics uses data to make conclusion about things. Both of them are covered in statistical machine learning, and a large part of that is **probability theory**, where we are going to start.

## Random Variable
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

The expression above indicates the probability for $X$ to have the value $x_1$