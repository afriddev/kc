### Deploy PostgreSQL

```bash
kubectl apply -f namespace.yaml
kubectl apply -f secrets/postgresql-secret.yaml
kubectl apply -f postgres/postgresql-configmap.yaml
kubectl apply -f postgres/postgresql-pvc.yaml
kubectl apply -f postgres/postgresql-deployment.yaml
kubectl apply -f clusterip-services/postgresql-clusterip-service.yaml
```

### Wait for PostgreSQL to be ready

```bash
kubectl wait --for=condition=ready pod -l app=postgres -n his-keycloak-postgresql --timeout=180s
```

### Deploy Keycloak

```bash

kubectl apply -f secrets/keycloak-secret.yaml
kubectl apply -f keycloak/keycloak-user-job.yaml
kubectl apply -f rbac/keycloak-rbac.yaml
kubectl apply -f headless-services/keycloak-service-headless.yaml
kubectl apply -f nodeport-services/keycloak-nodeport-service.yaml
kubectl apply -f keycloak/keycloak-statefulset.yaml
kubectl apply -f keycloak/keycloak-hpa.yaml
kubectl apply -f keycloak/keycloak-pdb.yaml
```

### Secret Updates

#### Update Keycloak Secret Only

```bash
kubectl apply -f secrets/keycloak-secret.yaml
kubectl rollout restart statefulset/keycloak -n his-keycloak
```

#### Update PostgreSQL Secret Only

```bash
kubectl apply -f secrets/postgresql-secret.yaml
kubectl rollout restart deployment/postgres -n his-keycloak-postgresql
```

#### Update PostgreSQL Secret (DB Password Changed)

```bash
kubectl apply -f secrets/postgresql-secret.yaml
kubectl rollout restart deployment/postgres -n his-keycloak-postgresql

kubectl apply -f secrets/keycloak-secret.yaml
kubectl rollout restart statefulset/keycloak -n his-keycloak
```

---

### Non-Secret Updates

#### Any Other YAML File (StatefulSet, Service, HPA, ConfigMap, etc.)

```bash
kubectl apply -f <file>.yaml
```

#### Watch Keycloak Pods Status

```bash
kubectl get pods -n his-keycloak -w
```

### Disable SSL Requirement in Keycloak

#### Exec into your Keycloak pod

```bash
kubectl exec -it keycloak-0 -n his-keycloak -- bash
```

#### Navigate to the bin directory

```bash
cd /opt/keycloak/bin
```

#### Authenticate with admin CLI (DO NOT include /auth in the URL for v26)

```bash
./kcadm.sh config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin
```

#### Disable SSL requirement

```bash
./kcadm.sh update realms/master -s sslRequired=NONE
```

#### Exit the pod

```bash
exit
```

### Note : Dont run this unless you want to delete data:

```bash
# Deletes actual data
kubectl delete pvc <pvc-name>
```

```bash
# Deletes everything including PVCs
kubectl delete namespace his-keycloak-postgresql
```

```bash
# Special flag to keep PVCs
kubectl delete statefulset --cascade=orphan
```
