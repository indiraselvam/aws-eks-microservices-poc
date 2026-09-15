# EKS Microservices POC — CI/CD Deployment

This project deploys a small production-style sample application to an existing AWS EKS cluster.

## Architecture

Browser -> AWS Load Balancer -> Frontend (Nginx) -> Backend (ClusterIP) -> RDS PostgreSQL

CI/CD:

GitHub -> GitHub Actions (OIDC) -> ECR -> EKS

## Prerequisites

- Existing EKS cluster
- Existing private RDS PostgreSQL database
- kubectl configured locally
- Two ECR repositories:
  - poc-frontend
  - poc-backend
- GitHub OIDC IAM role with ECR push and EKS deployment permissions

## 1. Create ECR repositories

```bash
aws ecr create-repository --repository-name poc-frontend --region ap-south-1
aws ecr create-repository --repository-name poc-backend --region ap-south-1
```

If they already exist, skip these commands.

## 2. Create Kubernetes namespace

```bash
kubectl apply -f k8s/namespace.yaml
```

## 3. Create the application database secret

Do NOT commit database credentials to Git.

Replace the values with your RDS details:

```bash
kubectl create secret generic rds-secret \
  -n microservices \
  --from-literal=DB_HOST='YOUR_RDS_ENDPOINT' \
  --from-literal=DB_PORT='5432' \
  --from-literal=DB_NAME='employees' \
  --from-literal=DB_USER='YOUR_DB_USER' \
  --from-literal=DB_PASSWORD='YOUR_DB_PASSWORD'
```

Create the database/table using `database/init.sql` if your RDS database is empty.

## 4. Test locally (optional)

Backend:

```bash
cd backend
npm install
npm start
```

Frontend:

```bash
cd frontend
npm install
npm run build
```

The production container is served by Nginx.

## 5. GitHub configuration

Add these GitHub Actions secrets:

- `AWS_ROLE_ARN` — IAM role trusted by GitHub OIDC
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

The workflow also creates/updates the Kubernetes `rds-secret` from these GitHub secrets. No database password is stored in Git.

Set the repository/branch trust in your IAM role before running the workflow.

## 6. CI/CD

Push to `main`:

```bash
git add .
git commit -m "Deploy sample microservices"
git push origin main
```

The workflow:

1. Checks out source
2. Logs into AWS using OIDC
3. Logs into ECR
4. Builds frontend and backend images
5. Pushes immutable commit-SHA image tags
6. Updates the Kubernetes RDS secret
7. Applies Kubernetes manifests
8. Sets the frontend/backend images to the new SHA
9. Waits for rollout completion

## 7. Verify

```bash
kubectl get pods -n microservices
kubectl get svc -n microservices
kubectl rollout status deployment/frontend -n microservices
kubectl rollout status deployment/backend -n microservices
```

The frontend service is `LoadBalancer`. Get its URL:

```bash
kubectl get svc frontend -n microservices
```

Open the EXTERNAL-IP/hostname in a browser.

## Notes

- Backend is ClusterIP and is not directly exposed to the internet.
- Frontend Nginx proxies `/api/*` to the backend Kubernetes service.
- Kubernetes Secret is used for RDS credentials.
- Images are tagged with Git commit SHA rather than `latest`.
- Deployment uses readiness/liveness probes and resource requests/limits.
- For a larger production setup, replace the frontend `LoadBalancer` with AWS Load Balancer Controller + Ingress and use AWS Secrets Manager/External Secrets for database credentials.
