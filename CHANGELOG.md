## terraform-aws-org-new-account-iam-role Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### [3.0.0](https://github.com/plus3it/terraform-aws-org-new-account-support-case/releases/tag/3.0.0)

**Released**: 2025.10.20

**Summary**:

* Updates min aws provider version to v6

### [2.0.2](https://github.com/plus3it/terraform-aws-org-new-account-support-case/releases/tag/2.0.2)

**Released**: 2025.05.07

**Summary**:

* Exposes lambda runtime as input variable, defaults to python3.12

### [2.0.1](https://github.com/plus3it/terraform-aws-org-new-account-support-case/releases/tag/2.0.1)

**Released**: 2023.04.18

**Summary**:

* Simplifies event rule patterns, relying only on details from cloudtrail event

### 1.0.0

**Commit Delta**: [Change from 0.2.2 release](https://github.com/plus3it/terraform-aws-org-new-account-support-case/compare/0.2.2...1.0.0)

**Released**: 2022.11.09

**Summary**:

*   Simplifies exception handling with a global handler that logs all exceptions
*   Improves event pattern to eliminate loop/wait logic in lambda function.
*   Separates the CreateAccountResult and InviteAccountToOrganization patterns into two event rules.
*   Changed lambda module to one published by terraform-aws-modules, for better long-term support
*   Exposed new `lambda` variable that wraps arguments for the upstream lambda module
*   Added support for creating multiple instances of this module. This achieved by either:
    *   Tailoring the artifact location, by setting `lambda.artifacts_dir` to a different location for each instance
    *   Creating the package separately from the lambda functions, see `tests/test_create_package_separately` for an example

### 0.2.2

**Commit Delta**: [Change from 0.2.1 release](https://github.com/plus3it/terraform-aws-org-new-account-support-case/compare/0.2.1...0.2.2)

**Released**: 2021.07.22

**Summary**:

*   Moved common requirements to `requirements_common.txt`.  Dependabot
    does not want to see duplicate requirements.

*   Updated the `Makefile` to take advantage of new targets in tardigrade-ci.

*   Updated the Travis workflow to reflect changes in tardigrade-ci

### 0.2.1

**Commit Delta**: [Change from 0.2.0 release](https://github.com/plus3it/terraform-aws-org-new-account-support-case/compare/0.2.0...0.2.1)

**Released**: 2021.05.28

**Summary**:

*   Corrects lambda policy to allow support:DescribeCases.

### 0.2.0

**Commit Delta**: [Change from 0.1.1 release](https://github.com/plus3it/terraform-aws-org-new-account-support-case/compare/0.1.1...0.2.0)

**Released**: 2021.04.29

**Summary**:

*   Revise integration test so it can successfully complete the lambda
    invocation.

### 0.1.1

**Commit Delta**: [Change from 0.1.0 release](https://github.com/plus3it/terraform-aws-org-new-account-support-case/compare/0.1.0...0.1.1)

**Released**: 2021.04.28

**Summary**:

*   Use a different docker name for the integration tests.

### 0.1.0
    
**Commit Delta**: N/A

**Released**: 2021.04.09

**Summary**:
        
*   Add two more environment variables for Lambda:  SUBJECT and
    COMMUNICATION_BODY.  Permit the variable 'account_id' to be used within 
    the text of those two new environment variables.
*   Updated the Terraform configuration to add the policy document to
    provide the Lambda with permissions for 
    organizations:DescribeCreateAccountStatus.
*   Modified the unit tests to replace the monkeypatched function for
    get_account_id with a call to moto organizations service to set up an 
    obtain an organizations account ID.

### 0.0.0

**Commit Delta**: N/A

**Released**: 2021.03.30

**Summary**:

*   Initial release!
