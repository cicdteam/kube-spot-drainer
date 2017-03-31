# Gracefully drain AWS Spot nodes from Kubernetes

>NOTE: Based on https://github.com/mumoshu/kube-spot-termination-notice-handler

A Kubernetes DaemonSet to run 1 small container per node to periodically polls the [EC2 Spot Instance Termination Notices](https://aws.amazon.com/jp/blogs/aws/new-ec2-spot-instance-termination-notices/) endpoint.
Once a termination notice is received, it will try to gracefully stop all the pods running on the Kubernetes node, up to 2 minutes before the EC2 Spot Instance backing the node is terminated.

### Version

`kubectl v1.5.2` used to gain access to Kubernetes cluster

### Usage

    $ kubectl create -f kube-spot-drainer.yaml

### Avaiable docker images/tags

Tags denotes Kubernetes/`kubectl` versions.
Using the same version for your Kubernetes cluster and `kube-spot-drainer` is recommended.

* `pure/kube-spot-drainer:1.5.2`, `pure/kube-spot-drainer:latest`

## How it works

Each `kube-spot-drainer` pod polls the notice endpoint until it returns a http status `200`.
That status means a termination is scheduled for the EC2 spot instance running the handler pod.
On status `200` **kubectl drain `<nodename>`** runs.

