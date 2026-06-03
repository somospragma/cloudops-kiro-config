# Convenciones — Pragma CloudOps

## Terraform
- Usar módulos del catálogo `somospragma/` cuando existan
- Estructura: main.tf, variables.tf, locals.tf, outputs.tf, providers.tf
- Backend en S3 con DynamoDB locking
- Versiones pinneadas en providers y módulos
- Nomenclatura de recursos según PC-IAC-003

## Git
- PRs con conventional commits: feat:, fix:, chore:, docs:
- Branch naming: feature/, bugfix/, hotfix/
- No push directo a main — siempre PR
- Pipeline CI/CD en Azure DevOps

## Código
- IaC en Terraform (no CloudFormation manual)
- Scripts de automatización en Bash o Python
- Documentación en README.md de cada repo
- Sin código muerto ni recursos comentados en producción
