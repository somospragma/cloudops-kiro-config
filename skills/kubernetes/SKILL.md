---
name: kubernetes-eks
description: Guía para EKS y Kubernetes en Pragma. Usar cuando se trabaje con clusters EKS, deployments, services, helm charts, o troubleshooting de pods.
---

# Kubernetes (EKS) — Pragma CloudOps

## Arquitectura EKS
- EKS managed node groups (no self-managed)
- Fargate profiles para workloads stateless cuando aplique
- ALB Ingress Controller para routing HTTP
- Cluster Autoscaler o Karpenter para scaling

## Estándares de deployment
```yaml
# Todo deployment debe incluir:
metadata:
  labels:
    app: nombre-app
    environment: dev|poc|prod
    team: cloudops
    project: sopp
spec:
  replicas: 2  # mínimo 2 en producción
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 512Mi
```

## Namespaces
- `prod` — Workloads de producción
- `dev` — Desarrollo
- `monitoring` — Datadog agent, métricas
- `ingress` — Controllers de ingress

## Seguridad
- IRSA (IAM Roles for Service Accounts) para acceso a AWS
- Network Policies para aislamiento entre namespaces
- No correr containers como root
- Image scanning con ECR scan on push
- Secrets via External Secrets Operator + AWS Secrets Manager

## Monitoreo
- Datadog agent como DaemonSet
- APM traces en todos los servicios
- Logs centralizados en Datadog
- HPA basado en métricas custom cuando aplique

## Helm
- Charts versionados en ECR OCI registry
- Values por environment: values-dev.yaml, values-prod.yaml
- No usar `latest` tag en imágenes — siempre SHA o semver
