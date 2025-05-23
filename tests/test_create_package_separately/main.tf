module "test_create_package" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=v7.20.2"

  create_function = false
  create_package  = true

  recreate_missing_package = false

  runtime     = "python3.12"
  source_path = "${path.module}/../../lambda/src"
}

module "test_create_function" {
  source = "../.."

  cc_list            = "foo@example.com"
  communication_body = "foo body"
  subject            = "foo subject"

  lambda = {
    local_existing_package = "${path.module}/${module.test_create_package.local_filename}"
    create_package         = false
  }
}
