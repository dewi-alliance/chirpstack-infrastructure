# Chirpstack-Infrastructure

This repository contains Terraform and Helm definitions for a highly available Chirpstack V4 deployment configured with a Helium Network sidecar on AWS EKS.

The repo is broken down into four directories - `aws`, `kubernetes`,  `chirpstack`, and `helium` - respectively for deploying underlying AWS infrastructure (e.g., EKS, RDS, ElastiCache, etc.), Kubernetes system applications (e.g., ArgoCD, AWS Load Balancer Controller, External DNS, etc.), the Chirpstack application, and the Helium sidecar applications. Each of the directories contains a top-level `README.md` file that provides further information about the resources that get deployed and how to deploy the infrastructure defined in the directory.

This repo assumes prior knowledge of Chirpstack and Helium, and that a Helium Organizationally Unique Identifier (OUI) has been purchased. If not, however, please see the inline links for further reading on [Chirpstack V4](https://www.chirpstack.io/docs/), [Helium](https://www.helium.com/), and [running Chirpstack with Helium](https://docs.helium.com/iot/run-an-lns) prior to beginning here.

## Usage

When using this repo to deploy Chirpstack, it is intended that a fork be created so that the resources can be tailored to a variety of implementations and custom variables can be set. After making a fork, the resources must be deployed in the following directory order:
- `aws`
- `kubernetes`
- `chirpstack`
- `helium`

While the `aws` and `kubernetes` resources are to be actively deployed with Terraform, the `chirpstack` and `helium` applications are Helm templates configured to be deployed automatically in a GitOps manner via ArgoCD (deployed via the `kubernetes` directory).

## Application-Level Resources

After deploying:
- Argo, Grafana, and Chirpstack dashboards will be exposed with custom hostnames behind an AWS application load balancer configured for SSL termination and security group-based whitelisted CIDR access
- MQTT will be exposed with a custom hostname behind an AWS network load balancer configured for SSL termination with whitelisted CIDR access based on a load balancer security group
- Chirpstack Gateway Bridge instance(s) will be exposed a custom hostname behind an AWS network load balancer
- All credentials will be stored in AWS Secrets Manager

## Pre-Commit

The repo comes configured with [pre-commit](https://pre-commit.com/) Git hooks for performing Terraform formatting, linting, and doc creation based on the configuration defined at `.pre-commit-config.yaml` when making commits. To use the pre-commit hooks in a forked repo, [install pre-commit](https://pre-commit.com/#install), install the hook dependencies (e.g., [terraform-docs](https://github.com/terraform-docs/terraform-docs?tab=readme-ov-file#installation), [tflint](https://github.com/terraform-linters/tflint?tab=readme-ov-file#installation), and [jq](https://github.com/jqlang/jq?tab=readme-ov-file#installation)), and run `pre-commit install`. After doing so, anytime `git commit` is run, the git hooks will execute. Additional git hooks such as those for static analysis of Terraform templates for security issues and AWS cost estimates can be found at [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform?tab=readme-ov-file#available-hooks) by the legendary [Anton Babenko](https://www.antonbabenko.com/).
