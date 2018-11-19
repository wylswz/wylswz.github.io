# Deep Learning

## Background

### What is deep learning?
- More neurons
- More complex ways of connecting layers
- "Cambrian explosion" of computing power in training
- Auto feature extraction

### Some typical architectures
- Unsupervised pretrained networks
- CNN
- Recurrent neural networks
- Recursive neural networks

### Applications

- **Inceptionsim** is a technique in which a trained CNN is taken with its layers in reverse order and given an input image coupled with a prior constraint. The images are modified iteratively to enhance the output in a manner that could be described as hallucinative.
- **Modelling artistic style** CNN extracts the artist's style into networks' parameters which can later be applied to arbitrary images


### Building blocks

- RBMS
- Autoencoders

### Optimization mathods

- **First order** Calculates the Jacobian matrix. The Jacobian has one partial derivative per parameter, other parameters are treated as constants. The algorithm then takes one step in the direction specified by the Jacobian.
    
    This takes the partial derivatives of each parameter (calculate the gradient at each step) to determine which direction to go next.

    Noisy gradient descent(SGD) is easy to implement and quick processing large dataset. You can adjust SGD by adapting the learning rate or using second order information. SGD is also a porpular algorithm for training neural networks due to its robustness in the face of noisy updates. That is, it helps you build models that generalize well.

- **Second order** Methods calculate the derivative of the Jacobian by approximating the Hessian. This takes into account interdependencies between parameters when choosing how much to modify each paramter.

    [Hessian](https://en.wikipedia.org/wiki/Hessian_matrix) is like derivative of Jacobian. That is, a matrix of second-order partial derivatives. The Hessian' job is to describe the curvature of each point of the Jacobian.

    - L-BFGS which is also called quasi-Newton method, and it limits how much gradient is stored in the memory. It does not compute full Hessian matrix which is quite expensive.
    - Conjugate gradient guides the direction of line search process based on conjugate information. Conjugate gradient methods focus on minimizing the conjugate L2 norm. Conjugate gradient is quite similar to gradient descent in that  it performs line search. The major difference is that conjugate gradient requires each successive step in the line search process to be conjugate to one another with respect to direction.
    - Hessian free.

Second order methods can take better steps, however, each step will take longer to calculate

### Building blocks of Deep Networks