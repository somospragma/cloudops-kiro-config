---
name: terraform-pragma
description: Guía de Terraform para Pragma. Usar cuando se escriba, revise o depure código Terraform, módulos, o pipelines de IaC.
---

# Terraform — Pragma CloudOps

## Estándar de proyecto (PC-IAC)
```
├── main.tf           # Recursos y módulos
├── variables.tf      # Declaración de variables
├── locals.tf         # Transformaciones y data structures
├── outputs.tf        # Outputs del módulo/root
├── providers.tf      # Provider configuration
├── data.tf           # Data sources
├── environments/
│   └── prod/
│       ├── terraform.tfvars
│       └── .env.yaml
└── azure-pipeline.yaml
```

## Flujo de ejecución (PC-IAC-026)
```
terraform.tfvars → variables.tf → locals.tf → main.tf → module
```

## Convenciones
- **Versiones**: Terraform >= 1.14.0, AWS Provider >= 6.20.0
- **Backend**: S3 + DynamoDB para state locking
- **Módulos**: Usar catálogo `somospragma/cloudops-ref-repo-*`
- **Nomenclatura**: `{client}-{project}-{environment}-{resource}`
- **Tags**: Siempre incluir los 7 tags obligatorios de SOPP

## Módulos internos disponibles
- `cloudops-ref-repo-aws-organization-scp-terraform` — SCPs
- `cloudops-ref-repo-aws-vpc-terraform` — VPCs
- `cloudops-ref-repo-aws-ecs-terraform` — ECS clusters
- `cloudops-ref-repo-aws-rds-terraform` — RDS/Aurora

## Pipeline CI/CD
- Azure DevOps con template `pragma-azure-devops-tf-pipeline`
- Stages: validate → plan → apply (manual approval en prod)
- State en S3 con encrypt + versioning

## Anti-patrones a evitar
- No usar `terraform apply -auto-approve` en producción
- No usar `count` para recursos complejos — preferir `for_each`
- No hardcodear ARNs — usar data sources
- No dejar resources sin tags
