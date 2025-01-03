Lambda functions are deployed into AWS by Terraform, deployed functions are placed in code folder, folder name is a variable of this module.

```
Create JWT_SECRET by command:
> openssl rand -hex 32

After create token, copy it into .env file
```