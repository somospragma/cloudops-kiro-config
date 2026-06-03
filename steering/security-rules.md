# Reglas de Seguridad — Pragma CloudOps

## Credenciales
- Nunca hardcodear credenciales, API keys, o tokens en código
- Usar AWS Secrets Manager o SSM Parameter Store para secretos
- No crear IAM Users — usar IAM Roles con SSO (IAM Identity Center)
- No generar access keys para root

## Red
- No abrir Security Groups a 0.0.0.0/0 en puertos sensibles (22, 3389, 3306, 5432)
- Usar VPC endpoints para servicios AWS cuando sea posible
- Todo tráfico público debe pasar por WAF o CloudFront

## Permisos
- Principio de menor privilegio: solo los permisos necesarios
- No usar `*` en Resource de policies IAM en producción
- Roles de servicio deben tener boundary policies

## Cifrado
- S3 buckets siempre con encryption at rest (SSE-S3 o SSE-KMS)
- RDS/Aurora siempre con encryption enabled
- EBS volumes encrypted por defecto
