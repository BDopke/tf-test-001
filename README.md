## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.package](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluence_api_key"></a> [confluence\_api\_key](#input\_confluence\_api\_key) | Confluence API key (being set using environment variable TF\_VAR\_confluence\_api\_key) | `string` | `null` | no |
| <a name="input_confluence_mail_address"></a> [confluence\_mail\_address](#input\_confluence\_mail\_address) | Confluence mail address (being set using environment variable TF\_VAR\_confluence\_mail\_address) | `string` | `null` | no |
| <a name="input_confluence_parent_page_id"></a> [confluence\_parent\_page\_id](#input\_confluence\_parent\_page\_id) | Confluence page parent ID under which page with report will be generated | `string` | `""` | no |
| <a name="input_confluence_space"></a> [confluence\_space](#input\_confluence\_space) | Confluence space key | `string` | n/a | yes |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | List of domain addresses (HTTP/S endpoints) | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region (being set using environment variable TF\_VAR\_region) | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security groups IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
