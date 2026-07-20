---
description: 'Write, test, or convert Terraform Policy files (.policy.hcl, .policytest.hcl, Sentinel→tfpolicy). Triggers: policy.hcl, policytest, convert sentinel, tfpolicy, write a policy.'
license: MPL-2.0
metadata:
    copyright: Copyright IBM Corp. 2026
    github-path: terraform/policy/skills/terraform-policy
    github-ref: refs/heads/main
    github-repo: https://github.com/hashicorp/agent-skills
    github-tree-sha: 317a3d695b147b1d8c116124aadcfac7cbc0f2af
    version: 0.1.0
name: terraform-policy
---
# terraform-policy

**UTILITY SKILL** — INVOKES: [tfpolicy-author](references/tfpolicy-author.md) | [tfpolicy-test](references/tfpolicy-test.md)

## USE FOR:

- Writing a new `.policy.hcl` policy from a description or requirement
- Converting a `.sentinel` policy to Terraform Policy
- Writing or debugging a `.policytest.hcl` test file
- Migrating a Sentinel policy library to Terraform Policy

## DO NOT USE FOR:

- Writing `.tftest.hcl` files for Terraform modules — use `terraform-test`
- General Terraform HCL authoring — use `terraform-style-guide`

## Routing

| Task | Sub-skill |
|------|-----------|
| Write or convert a `.policy.hcl` policy | [tfpolicy-author](references/tfpolicy-author.md) |
| Write or debug a `.policytest.hcl` test | [tfpolicy-test](references/tfpolicy-test.md) |

## Examples

- "Block EC2 instances without encryption" → [tfpolicy-author](references/tfpolicy-author.md)
- "Convert this Sentinel policy to tfpolicy" → [tfpolicy-author](references/tfpolicy-author.md)
- "Write a policytest for my EBS policy" → [tfpolicy-test](references/tfpolicy-test.md)

## Troubleshooting

- **Wrong skill triggered?** Load the sub-skill directly from the routing table above.

```bash
npx skills add hashicorp/agent-skills/terraform/terraform-policy/skills/tfpolicy-author
npx skills add hashicorp/agent-skills/terraform/terraform-policy/skills/tfpolicy-test
```
