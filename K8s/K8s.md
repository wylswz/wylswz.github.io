# Some tips on k8s

## Account and service account

When users manipulate kubernetes cluster via kubectl on command line, they are sending these API requests via an account, which is `default` if not explicitly declared. Same thing happens when some services (deployed in pods) call k8s APIs, they are actually assigned to an account which is called service account.

Each account has its permission to access to various types of resources, e.g., pods, volumes, namespaces with different actions, e.g., list, get, watch. The way it is authorized is by access token. When a new service account is created, a randon access token is generated with it.

In order to access the token in service, we have to declare a special type of `Secret` pointing the the service account and mount it to the pods where you wanna access your toekn.

## Role based access control (RABC)
K8s controls accounts' access to resources with `RABC` mechanism. `RABC` has two core features, which are `Roles` and `RoleBinding`. A `Role` is simply a set if rules or we say permissions, which can either be cluster-wise or namespace-wise. These rules are purely additive, which means the role is the sum of rules which allows you to do something. None of those rules rejects any access.

`RoleBining` is how we bind rols to service accounts.

## Providing services using `Ingress` resource
`Ingress` defines a set of rules of how services can be accessed, including the `url`, `backing services` and other information(looks like a router).

`Ingress` won't work on itself because it is nothing but a set of rules, that's where `Ingress Controller` comes in. The job of `Ingress Controller` is automatically programming a front-end load balancer and enable `Ingress` configuration. There are multiple `Ingress Controller` implementations. `Nginx Ingress Controller` is one of those. 

Installing an `Ingress Controller` is nothing but launching a special pod with some simple configurations. Details can be found on official website but we can make it fairly simple with a few sentances:

- First we create a namespace and a service account for it
- Create cluster role and cluster role binding
- Create secret
- Create configmap
- Custom resource definition for `VirtualServer` or `Ingress`



## Deploying Minikube in Proxy env
In order to use proxy settings in Minikube(proxy server is running on host machine) it is necessary to set proxy address as host ip instead of `127.0.0.1`. We can use following commands to set environment variables.

```sh
IP=`ifconfig {your network device name} | grep 'inet addr' | cut -d: -f2 | cut -d " " -f1`
# cut -d: -f2 means splitting the line with ':' and take second field 

export HTTP_PROXY=${IP}:1091
export HTTPS_PROXY=${IP}:1091
export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24

```

## Extend the ability of kubernetes with custom controller

Kubernetes has some pre-defined controllers and APIs when it's installed, like replicaset, services, pods. The job of a controller is to maintain the desired state of the cluster. For example, if you define a deployment with replicas equals to three, and there are only 2 pods available in the cluster, the controller will attempt to create another one pod, and let tge scheduler to schedule it.

Kuernetes allow developers to develop their own controllers & resources. There is a framework called `kubebuilder`, which does some of those dirty work for you, like code generation, config file generation, etc. All you need to do is to define the struct of your custom resource as well as some tags for serialization/deserialization. The `kubebuilder` automatically generates codes like `DeepCopy` methods, `WebHooks`, `Ca injections` and controller it self. After your resource is defined, just go ahead and implement the `reconcile` method to do whatever you want based one the current state of your custom resource you received from kubernetes. 

When implementing the `reconcile` method, you probably wanna look at the spec method for expected state of the CR or another resources in the cluster, then you do something fancy to modify the state of resources to make it match the spec.

You can also implement your own admission webhook for your CRD, including some data verification or what ever you want. In order to enable webhook, you will need to add something like `ValidatingWebhookConfiguration` to your cluster, specifying webhook addresses or service reference to tell admission controller where the reqest should send to. In `kubebuilder` framework, this address is generated for you, which is a combination of api name, group name, api version and type of admission wehook(`mutate` or `validate`). Also, `kubebuilder` generates cert manager tools for you, like ca injectors which and some side cars to automatically handle SSL for you. You will need to install cert-manager in your cluster for this to work.