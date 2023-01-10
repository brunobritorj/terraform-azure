# Az DevOps (ADO) agent running on Az Container Instance (ACI)

Mandatory Terraform variables with no default values:

- AZP_URL
- AZP_TOKEN

```
terraform apply -var="AZP_URL=https://dev.azure.com/{your_org_name}" -var="AZP_TOKEN={your_pat_token}"
```
