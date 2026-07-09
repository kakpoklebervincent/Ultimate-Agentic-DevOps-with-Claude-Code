---
name: security-audit-checklist
description: Standing checklist and severity conventions used for AWS/Terraform security audits in this repo
metadata:
  type: feedback
---

When auditing `terraform/` in this repo, apply this checklist (from the invoking agent's
instructions) consistently across reviews:

- S3: public access block (all 4 flags true), bucket policy least-privilege + `aws:SourceArn`
  condition scoped to the specific CloudFront distribution ARN (not just service principal),
  versioning enabled, SSE (SSE-S3 or SSE-KMS) enabled, access logging enabled, and a policy
  statement denying non-TLS requests (`aws:SecureTransport = false` -> Deny).
- CloudFront: `viewer_protocol_policy = "redirect-to-https"` (not `allow-all`), OAC (not legacy
  OAI — `aws_cloudfront_origin_access_control`, not `aws_cloudfront_origin_access_identity`),
  explicit `minimum_protocol_version` (e.g. `TLSv1.2_2021`) when a custom ACM cert is used, and a
  `aws_cloudfront_response_headers_policy` attached for CSP/X-Frame-Options/HSTS/etc. Also check
  for a mismatch between `aliases` being conditionally set from a domain variable while
  `viewer_certificate` unconditionally uses `cloudfront_default_certificate = true` — CloudFront
  will reject aliases without a matching ACM cert, and even if valid, this is a TLS-version bug.
- IAM/OIDC: the GitHub Actions deploy role's trust policy must condition on `token.actions
  .githubusercontent.com:sub` scoped to a specific `repo:org/repo:ref:refs/heads/branch` (not a
  bare `repo:org/repo:*` or unconditioned trust). Flag if the role/trust policy isn't even defined
  in Terraform (see [[project-portfolio-infra-gaps]] for this repo's specific instance).
- Backend: remote state must use `encrypt = true` and locking (`use_lockfile` or DynamoDB table);
  flag if state bucket itself has no versioning/public-access-block defined anywhere in code.
- Treat hardcoded account IDs/ARNs/bucket names/distribution IDs in CI workflow files
  (`.github/workflows/*.yml`) as in-scope findings even when the audit task nominally scopes to
  `terraform/`, since they reveal the same class of issue (secrets/identifiers baked into code
  instead of Terraform outputs or repo variables).

**Why:** This is the standing checklist the user's security-auditor agent definition provides;
keeping it in memory avoids re-deriving severity judgment calls each time and keeps findings
consistent across repeated audits of this repo.

**How to apply:** Re-verify each item against current file contents before reporting — do not
assume a past finding still holds; the code may have been fixed since the last audit.
