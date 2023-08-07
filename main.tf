data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "policy_definition" {
  statement {
    sid = "AllowEC2"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "LogsCreateLogGroup"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:*"
    ]
  }

  statement {
    sid = "LogPushLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda.function_name}:*",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "pre-onboarding-validator-policy"
  policy = data.aws_iam_policy_document.policy_definition.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role" "role" {
  name               = "PreOnboardingValidatorRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "package" {
  type        = "zip"
  source_dir  = "source"
  output_path = "payload.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "payload.zip"
  function_name = "pre-onboarding-validator"
  role          = aws_iam_role.role.arn
  handler       = "lambda_function.handler"
  timeout       = 180

  source_code_hash = data.archive_file.package.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      CONFLUENCE_URL            = "https://nordcloud.atlassian.net/"
      CONFLUENCE_MAIL_ADDRESS   = var.confluence_mail_address
      CONFLUENCE_API_KEY        = var.confluence_api_key
      CONFLUENCE_SPACE          = var.confluence_space
      CONFLUENCE_PARENT_PAGE_ID = var.confluence_parent_page_id
      ENDPOINTS                 = var.endpoints
    }
  }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }
}

resource "terraform_data" "invoke_lambda" {
  depends_on = [aws_lambda_function.lambda]
  
  provisioner "local-exec" {
    command = "aws lambda invoke --function-name ${aws_lambda_function.lambda.function_name} --log-type Tail --output json"
  }
}