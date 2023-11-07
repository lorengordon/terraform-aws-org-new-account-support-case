locals {
  name = "new-account-support-case-${random_string.id.result}"
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "support:CreateCase",
      "support:DescribeCases"
    ]

    resources = [
      "*",
    ]
  }
}

module "lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=v6.4.0"

  function_name = local.name

  description = "Create new account support case - ${var.subject}"
  handler     = "new_account_support_case.lambda_handler"
  runtime     = "python3.8"
  timeout     = 300
  tags        = var.tags

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.lambda.json

  source_path = [
    {
      path             = "${path.module}/lambda/src"
      pip_requirements = true
      patterns         = try(var.lambda.source_patterns, ["!\\.terragrunt-source-manifest"])
    }
  ]

  artifacts_dir            = var.lambda.artifacts_dir
  create_package           = var.lambda.create_package
  ignore_source_code_hash  = var.lambda.ignore_source_code_hash
  local_existing_package   = var.lambda.local_existing_package
  recreate_missing_package = var.lambda.recreate_missing_package
  ephemeral_storage_size   = var.lambda.ephemeral_storage_size
  s3_bucket                = var.lambda.s3_bucket
  s3_existing_package      = var.lambda.s3_existing_package
  s3_prefix                = var.lambda.s3_prefix
  store_on_s3              = var.lambda.store_on_s3

  environment_variables = {
    CC_LIST            = var.cc_list
    COMMUNICATION_BODY = var.communication_body
    LOG_LEVEL          = var.log_level
    SUBJECT            = var.subject
  }
}

resource "random_string" "id" {
  length  = 8
  special = false
}

locals {
  event_types = {
    CreateAccountResult = jsonencode(
      {
        "detail" : {
          "eventSource" : ["organizations.amazonaws.com"],
          "eventName" : ["CreateAccountResult"]
          "serviceEventDetails" : {
            "createAccountStatus" : {
              "state" : ["SUCCEEDED"]
            }
          }
        }
      }
    )
    InviteAccountToOrganization = jsonencode(
      {
        "detail" : {
          "eventSource" : ["organizations.amazonaws.com"],
          "eventName" : ["InviteAccountToOrganization"]
        }
      }
    )
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.event_types

  name          = "${local.name}-${each.value}"
  description   = "Managed by Terraform"
  event_pattern = local.event_types[each.value]
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = aws_cloudwatch_event_rule.this

  rule = each.value.name
  arn  = module.lambda.lambda_function_arn
}

resource "aws_lambda_permission" "events" {
  for_each = aws_cloudwatch_event_rule.this

  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = each.value.arn
}
