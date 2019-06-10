# Parallel Decoder
Parallel decoder is a data streaming source which works like native Python generator, except that the computational part of generating data sample is delegated to a multi-processing computing module. It can be treated as a parallel version of generator.

## Motivation
The idea of this project came from my last machine learning project which is about human face comparison. We were training a Siamese network which takes a pair of images as input each time. As we increase complexity of image decoding, the data feeding speed becomes the bottlenect, so I came up with this idea. 

A Parallel Decoder is designed to have following features:
- Compatible with native generator. It should implement all the behaviors that a native generator has, in order to fit seamlessly to any system that uses generator
- Parallelize the computational expensive part. The user should be able to decouple the original behavior into two parts. First part is like streaming from metadata, which is quite fast, and the second part does expensive data decoding. These are done during the instanciation of the class, so that would affect the behavior of high level inerface.
- (Potentially) scalable. It would be better of the parallel part can be scaled up to cluster level.