


# Deep Learning



- [Deep Learning](#deep-learning)
    - [Background](#background)
        - [What is deep learning?](#what-is-deep-learning)
        - [Some typical architectures](#some-typical-architectures)
        - [Applications](#applications)
        - [Building blocks](#building-blocks)
        - [Optimization mathods](#optimization-mathods)
        - [Building blocks of Deep Networks](#building-blocks-of-deep-networks)
        - [Some architectures](#some-architectures)
            - [Deep belief networks (Overtaken by CNN)](#deep-belief-networks-overtaken-by-cnn)
                - [Feature extraction with RBM Layers](#feature-extraction-with-rbm-layers)
                - [Initializing the feed-forward network](#initializing-the-feed-forward-network)
                - [Gentle bp](#gentle-bp)
            - [Generative Adversarial Networks](#generative-adversarial-networks)
            - [CNN](#cnn)
                - [ReLU](#relu)
                - [Activation Map](#activation-map)
    - [Start doing deep learning](#start-doing-deep-learning)
        - [CNN](#cnn-1)
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
Deep netowrks combine smaller networks as building blocks. Here are some building blocks:

- Feed-forward multilayer neural networks
- RBMs (Restricted Boltzmann Machines)
    - Ristrict means that connections between nodes of same layer are prohibited. No visible-visible or hidden-hidden connection.
    - RBMs are also a type of autoencoder
    - 
- Autoencoders
  Used to learn compressed representations of dataset(Reduce the dimension). The output of the auto encoder network is a reconstruction of the input data in the most efficient form.

    It differs from multi-layer perceptrons is that autoencoder has input and output layer with same size. It builds a compressed version of data. Autoencoder uses unlabeled data in unsupervised learning.

    - **Compression autoencoder** The network input must pass through the bottleneck region before being expanded into output
    - **Denoising autoencoder** Given corrupted data, network learns uncorrupted data.


### Some architectures

#### Deep belief networks (Overtaken by CNN)
DBNs are composed of layers of RBMs for the pretrain phase and then a feed-forward network for the fine-tuning phase.

##### Feature extraction with RBM Layers
We ask RBM to reconstruct, it generates something pretty close to the original input vector. (Machine dream about data)

This is to learn these high level featues of a dataset in an unsupervised training fashion.

##### Initializing the feed-forward network
We then use these layers of features as initial weights in a traditional bp driven feed-forward NN. These initializations help training algorithms guide the parameters of the traditional NN towards better regions of parameter search space. This phase is known as fine-tune phase.

##### Gentle bp


#### Generative Adversarial Networks

GANs are an example of a network that uses unsupervised learning to train two models in parallel. A key aspect of GANs is how they use a parameter count that is significantly smaller than normal wrt the amount of data on which they're training the network. The network is forced to efficiently represent the training data, making it more efficient data similar to the training data.

Given a large corpus of training images, we could build a generative NN that outputs images. We'd consider these generated output images to be samples from the model. The generative model in GANs generages such images while a secondary discriminiator network tries to classify these generated images.

The discriminator network is typically a standard CNN. Using a secondary NN as discriminator network allows GAN to train both NN in parallel in an unsupervised fashion. These discriminator networks takes images as input and output a classification.

The generative network in GANs generates data with a special kind of layer called deconvolutional layer. During training, use BP on both net. The goal is to update the generative net's parameters such that it fools the discrinimator net, because the output is so realistic compared to the real images.


#### CNN
Three major groups:
- Input layer
- Feature-extraction layers
    
    Repeated pattern of:
        - Convolution layer
        - Pooling layer
- Classification layer


##### ReLU
Why use ReLU in CNN?

ReLU (Rectified Linear Unit) crop the value at 0. It is easy to calculate and can accelerate the convergence due to linear property. But the train can die due to large gradient flow.

Leaky ReLU introduce a very small slope when $x<0$


##### Activation Map
Also referred to as feature map, calculated by sliding the kernel.

<<<<<<< HEAD


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