---
name: project-portfolio-infra-gaps
description: Known security/config gaps in this repo's S3+CloudFront+OIDC deployment, found during terraform/ audits
metadata:
  type: project
---

As of 2026-07-09, `terraform/` (providers.tf, variables.tf, main.tf, outputs.tf, backend.tf) only
provisions the S3 bucket, CloudFront distribution + OAC, and bucket policy. It does **not**
define the `github-actions-deploy` IAM role or its OIDC trust policy at all, even though
CLAUDE.md and `.github/workflows/deploy.yml` describe/use that role. The role is presumably
created manually in the AWS console/CLI, outside Terraform.

`.github/workflows/deploy.yml` hardcodes: AWS account ID `533267262133`, role ARN
`arn:aws:iam::533267262133:role/github-actions-deploy`, S3 bucket name
`pravinmishradmi-site-production`, and CloudFront distribution ID `E3V6O6MRE2E21P`, region
`eu-north-1`. `terraform/variables.tf` default region is `ap-south-1` — inconsistent with the
region actually used in the workflow/CLAUDE.md (eu-north-1). This mismatch means the default
`terraform apply` (no -var overrides) would provision resources in the wrong region relative to
what deploy.yml expects.

`terraform/backend.tf` intentionally ships with the S3 backend block commented out (bootstrap
chicken-and-egg: no state bucket exists yet on first apply). Local `terraform.tfstate` is
gitignored, so it isn't committed, but it is unencrypted on disk locally until someone migrates
to the S3 backend.

**Why this matters:** Since the IAM role/trust policy live outside Terraform, this repo's IaC
audits (via [[security-audit-checklist]]) cannot verify OIDC trust-policy scoping (repo/branch
conditions) from code — flag this as a gap/CRITICAL finding rather than assuming the role is
fine, and recommend importing it into Terraform (`aws_iam_role` + `aws_iam_openid_connect_provider`
data source) so it can be reviewed going forward.

**How to apply:** In future audits of this repo, re-check whether main.tf/iam.tf has grown an
`aws_iam_role`/OIDC resource before repeating this finding — it may have been fixed. Also re-check
whether backend.tf's S3 backend block has been uncommented/migrated.
