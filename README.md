
## Deployment instructions

1. Prerequisites - environment variables (see suggested values below):
- Setup s3 state bucket and dynamoDb locking for terraform
  - Create s3 bucket and add policies to hold our terraform state with this command: 
    - `aws s3api create-bucket --bucket {BUCKET_NAME} --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1`
    - `aws s3api put-bucket-encryption --bucket {BUCKET_NAME} --server-side-encryption-configuration "{\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}"`
    - `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name {TERRAFORM_USER}`
    - `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess --user-name {TERRAFORM_USER}`
  - Create bucket policy, put against bucket e.g.
    - `aws s3api put-bucket-policy --bucket my-terraform-backend-store --policy file://environments/staging/policy.json`
  - Enable versioning in bucket with 
    - `aws s3api put-bucket-versioning --bucket terraform-remote-store --versioning-configuration Status=Enabled`
  - Initial terraform comment out main.tf line
    - `dynamodb_table = "terraform-state-lock-dynamo"`
  - After initial terraform uncomment main.tf line
    - `dynamodb_table = "terraform-state-lock-dynamo"`


1. Initialize terraform with environment-specific configuration:
```
  cd ../environments/{admin/staging/production}

  terraform init
```

4. Run terraform plan with environment-specific variables:
```
  terraform plan -var-file="secrets.tfvars" -var-file="environment.tfvars" -out="terraform-plan.json"
```

5. Validate terraform changes and apply:
```
  terraform apply terraform-plan.json
```


## Todos

- Add a domain and TLS certificate
  - atm this has been setup with a self signed certificate. This was done like so;
    - Create self signed certificate
      - ````openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=example.com"```
    - base64 encode 
    -   ``` openssl base64 -in cert.pem -out cert.base64.pem
            openssl base64 -in key.pem -out key.base64.pem
        ```
    - Upload to AWS 
      - ```aws acm import-certificate --certificate file://cert.base64.pem --private-key file://key.base64.pem```

- CI/CD deployment (The container deployment is currently setup to pull images via dockerhub instead of ECR.) 
  - Pick a deployment style rolling, green/blue, canary

- Admin account: see ADRs.

