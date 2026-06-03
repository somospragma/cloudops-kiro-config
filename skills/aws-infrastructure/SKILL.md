---
name: aws-infrastructure
description: Guía para diseño y despliegue de infraestructura AWS en SOPP. Usar cuando se trabaje con VPCs, EC2, ECS, RDS, S3, IAM, networking o cualquier servicio AWS.
---

# AWS Infrastructure — SOPP

## Arquitectura de referencia
- Multi-account via AWS Organizations
- Networking: Transit Gateway entre cuentas
- Cómputo: ECS Fargate para contenedores, EC2 solo cuando sea necesario
- Bases de datos: Aurora PostgreSQL (prod), RDS PostgreSQL (dev/poc)
- Storage: S3 con lifecycle policies

## OUs de la organización
| OU | Propósito |
|----|-----------|
| Sopp_Platform_Core_Dev | Desarrollo |
| Sopp_Territory_Prod | Producción principal |
| Sopp_Territory_Colombia | Prod Colombia |
| Sopp_Territory_EEUU | Prod EEUU |
| Sopp_Territory_Mexico | Prod México |
| Sopp_Territory_CAC | Prod Centroamérica |
| Sopp_Infrastructure | Servicios compartidos |

## Servicios preferidos
- **Contenedores**: ECS Fargate con ALB
- **Serverless**: Lambda + API Gateway
- **Mensajería**: SQS + SNS
- **Cache**: ElastiCache Redis
- **CDN**: CloudFront
- **DNS**: Route53
- **Monitoreo**: Datadog (APM, Logs, Metrics)
- **IaC**: Terraform con módulos somospragma/

## Patrones de seguridad
- VPC con subnets privadas para workloads, públicas solo para ALB/NAT
- Security Groups restrictivos (no 0.0.0.0/0)
- KMS para encryption at rest
- CloudTrail habilitado en todas las cuentas
- GuardDuty activo
