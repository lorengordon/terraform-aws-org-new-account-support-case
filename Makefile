ONLY_MOTO := true
export PYTHONPATH := $(PYTHONPATH):./lambda/src

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)

.PHONY: pytest/deps
pytest/deps:
	@ echo "[@] Installing dependencies used for unit and integration tests"
	@ python -m pip install \
		-r requirements/requirements_dev.txt \
		-r requirements/requirements_test.txt

.PHONY: python/deps
python/deps:
	@ echo "[$@] Installing lambda dependencies"
	@ python -m pip install -r lambda/src/requirements.txt

.PHONY: mockstack/pytest/lambda
mockstack/pytest/lambda:
	@ echo "[$@] Running Terraform tests against LocalStack"
	DOCKER_RUN_FLAGS="--network terraform_pytest_default --rm -e LOCALSTACK_HOST=localstack" \
		TARDIGRADE_CI_DOCKERFILE=Dockerfile_test \
		IMAGE_NAME=new-account-support-case-integration-test:latest \
		$(MAKE) docker/run target=terraform/pytest
	@ echo "[$@]: Completed successfully!"
