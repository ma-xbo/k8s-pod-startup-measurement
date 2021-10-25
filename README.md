# Measure Pod Startup Time in Kubernetes

## 1. Clone the repository:
```bash
git clone https://github.com/ma-xbo/k8s-pod-startup-measurement.git
```

## 2. Check script configuration:
   - configure IMAGE_NAME
   - configure CONATINER_NAME
   - configure RUNTIME

```bash
nano k8s-pod-startup-measurement/scripts/script_ctr_container.sh
```

## 3. Run ctr script:
```bash
bash k8s-pod-startup-measurement/scripts/script_ctr_container.sh
```