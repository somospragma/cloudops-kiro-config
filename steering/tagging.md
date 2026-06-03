# Tags Obligatorios AWS — Proyecto SOPP

Todo recurso AWS debe incluir estos tags al momento de creación:

| Tag | Valores permitidos |
|-----|-------------------|
| `project` | sopp |
| `environment` | dev, poc, prod |
| `territory` | colombia, eeuu, mexico, cac, global |
| `country` | colombia, panama, guatemala, costa-rica, mexico, eeuu, honduras, global |
| `client` | (cualquier valor, obligatorio) |
| `owner` | (cualquier valor, obligatorio) |
| `cost-center` | 9952 |

## Reglas
- Si falta algún tag, la SCP bloqueará la creación del recurso
- Los roles con patrón `*apigateway*` están excluidos
- En Terraform usar bloque `tags {}` en cada resource
- Ejemplo mínimo:

```hcl
tags = {
  project      = "sopp"
  environment  = "dev"
  territory    = "colombia"
  country      = "colombia"
  client       = "mi-cliente"
  owner        = "equipo-cloudops"
  cost-center  = "9952"
}
```
