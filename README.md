# Measure Pod Startup Time in Kubernetes

## 1. Clone the repository:

```bash
git clone https://github.com/ma-xbo/k8s-pod-startup-measurement.git
```

## 2. Install alternative Container Runtime (e.g., gVisor, Kata Containers)

Note: To use Kata Containers, the host system must support nested virtualization.

```bash
bash k8s-pod-startup-measurement/runtime-installation/gvisor-installation.sh
bash k8s-pod-startup-measurement/runtime-installation/kata-installation.sh
```

## 3. Configure containerd

```bash
sudo nano /etc/containerd/config.toml
```

Add the container runtime, for example gVisor or Kata Containers, to the containerd configuration file:

```
...

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
  runtime_type = "io.containerd.runsc.v1"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata]
    runtime_type = "io.containerd.kata.v2"

...
```

## 4. Add Kubernetes RuntimeClass
```bash
sudo cat<<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1beta1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
EOF
```

```bash
sudo cat << EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1beta1
kind: RuntimeClass
metadata:
  name: kata
handler: kata
EOF
```

## 5. Check the configuration of the scripts:
  - configure IMAGE_NAME
  - configure CONATINER_NAME
  - configure RUNTIME

```bash
nano k8s-pod-startup-measurement/scripts/script_ctr_container.sh
nano k8s-pod-startup-measurement/scripts/script_kubectl_application.sh
nano k8s-pod-startup-measurement/scripts/script_kubectl_container.sh
```

## 6. Run one of the scripts:

```bash
bash k8s-pod-startup-measurement/scripts/script_ctr_container.sh
bash k8s-pod-startup-measurement/scripts/script_kubectl_application.sh
bash k8s-pod-startup-measurement/scripts/script_kubectl_container.sh
```
