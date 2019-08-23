# Cryptography

## Diffie-Hellman Idea

The problem: Two users want to share a common secret over a public network, is it possible?

- We need a one way function which is easy to get $x \rightarrow y$ but very hard to get $x$ from $y$
- Alice and Bob exchange some public information then calculate the shared secret key.

### One way function
One example of one-way function is discrete logarithm problem. Let 'g' and 'h' be elements of group G, then discrete logarithm problem is the problem of finding x such that $g^x = h$

For example, we are calculating $2^x mod 11$, then we get this 

![](./dlog.png)

This process is quite hard to be reversed, esecially when we have a real big x.

### Exchanging the key

![](./DH_keyexchange.png)

The exchange of key then becomes straightforward. Alice chooses a Na, and calculate Ma using one way function, then send it to Bob. Bob chooses a Nb and calculate Mb then send to Alice. We easily get $Mb^{Na} = Ma^{Nb}$, which can be used as shared key. Even if the attackers know Ma and Mb, they can hardly calculate the key.

The problem of DH key exchange is man-in-the-middle attack. Someone may pretent to be the peer in the middle to intfere the communication.


## RSA Idea

### RSA overview
RSA is one of the public key cryptography algorithm which allows encoding and decoding in both direction, that is, the message can either be encrypted with public key or private key. In RSA, the plain text and cipher text are integers between 0 to n-1, where n is 1024 typically. This integer is treated as one block.

The main idea of RSA is that given a message $M$, and a key $e$, the cipher text $M^e \mod n$ can be calculated given another key 
$d$ by $(M^e)^d \mod n$.