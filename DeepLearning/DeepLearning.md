# Deep Learning
- [Deep Learning](#deep-learning)
    - [Background](#background)
        - [What is deep learning?](#what-is-deep-learning)
        - [Some typical architectures](#some-typical-architectures)
        - [Applications](#applications)
        - [Building blocks](#building-blocks)
        - [Optimization mathods](#optimization-mathods)
        - [Building blocks of Deep Networks](#building-blocks-of-deep-networks)
    - [Start doing deep learning](#start-doing-deep-learning)
        - [CNN](#cnn)
        - [Estimator in tensorflow](#estimator-in-tensorflow)
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


## Start doing deep learning

### CNN
Convolutional neural networks is used for image classification. It consists of following components:

- **Convolutional layer** N 2-d convolution kernels is applied to the image to extract the features. This layer usually accepts following parameters.
    - Input: The input of the layer, this is image pixel values in most cases
    - Filters: Number of filters applied
    - Kernel_size: Size of the kernel, should be a 1-d array
    - Padding: Padding value outside the boundry, can be 'same', which extends the neighbour pixel
    - Activation function: An activation function applied to the convolution result, usually ReLU
- **Pooling layer** Usually a max-pooling layer, which shrink the size of the layer by a factor. It accepts following parameters:
    - Inputs: Input of the layer, should be the convolutional layer
    - Pool size: Size of the pool, 2-d array
    - Stride: How much the pool are separated
- **Dense layer (fully connected layer)** Fully connected layer, accepting following parameters
    - Inputs: This can be reshaped last pooling layer
    - Units: Number of neurons in this layer
    - Actication function: Usually ReLU
- **Dropout layer** Drop out units randomly during the training process. Parameters:
    - Inputs: Should be the fully connected layer which you want to drop units
    - Rate: Rate of dropping units
    - Training mode: Train or evaluate. Units are dropped only in training phase


### Estimator in tensorflow

In tensorflow you can use either pre-made estimators, which are fully baked, or customized estimators, which can be instanciated by overriding some functions. In particular, the only difference between pre-made estimator and customized ones is that you will need to write the model function.

There are three modes to be handled in a model function, which are TRAIN, PREDICT and EVALUATE. The function must reuturn corresponding EstimatorSpec for each case.