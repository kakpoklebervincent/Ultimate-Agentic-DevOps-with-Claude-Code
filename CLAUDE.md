# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Running locally

Open `index.html` directly in a browser, or serve the root over HTTP:

```bash
python -m http.server 8000   # then visit http://localhost:8000
```

## Architecture

Pure HTML5 and CSS3. No JavaScript. No build step. No framework.

## Deployment

`.github/workflows/deploy.yml` runs on every push to `main`:

1. Authenticates to AWS via **OIDC** (assumes IAM role `github-actions-deploy` in account `YOUR_ACCOUNT_ID`, region `eu-north-1`) — no long-lived credentials are stored.
2. `aws s3 sync` the repo root to bucket `YOUR_BUCKET_NAME` with `--delete`, **excluding** `.git/*`, `.github/*`, `.claude/*`, `terraform/*`, `.mcp.json`, `*.md`, and `CLAUDE.md`.
3. Invalidates CloudFront distribution `YOUR_DISTRIBUTION_ID` (`/*`).

Because sync uses `--delete`, a file removed from the repo is removed from the live site. Any new non-web file added to the root that should not be published must be added to the exclude list in `deploy.yml`.


## Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Commands
ls
claude
- `terraform init` — initialise Terraform
- `terraform plan` — preview infrastructure changes
- `terraform apply` — apply infrastructure changes

## Safety

Never put secrets in this file. No API keys, passwords, or AWS credentials.