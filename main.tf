data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
      ]
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:${var.account_id}:*"]
  }

  statement {
    actions   = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    effect   = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "pre-onboarding-validator-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role" "role" {
  name               = "PreOnboardingValidatorRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}

data "archive_file" "package" {
  depends_on = [ null_resource.install_packages ]
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

resource "null_resource" "invoke_lambda" {
  depends_on = [aws_lambda_function.lambda]

  provisioner "local-exec" {
    interpreter = ["powershell"]
    command     = "aws lambda invoke --function-name ${aws_lambda_function.lambda.function_name} --invocation-type Event --log-type Tail --output json output.json"
  }
}

resource "null_resource" "install_packages" {
  provisioner "local-exec" {
    interpreter = ["powershell"]
    command     = "pip install -r requirements.txt -t source/"
  }
}