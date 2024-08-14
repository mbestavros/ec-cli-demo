#!/usr/bin/env bash

########################
# include the magic
########################
. ~/.bin/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

pei "# store our image reference for easy use later"

pe "IMAGE='quay.io/konflux-ci/ec-golden-image@sha256:ff5e80b8a616385abba8dccf200e1b215dd0ec9af760144018e49cf279632be1'"

pei "# show the public key used for signing"

pe "cat cosign.pub"

pei "# Verify signature with cosign"

pe "cosign verify --key cosign.pub $IMAGE --insecure-ignore-tlog | jq -C | less -XSE"

pei "# Verify SLSA attestations with cosign"

pe "cosign verify-attestation --type slsaprovenance --key cosign.pub $IMAGE --insecure-ignore-tlog | jq -C | less -XSE"

pei "# Use ec with an empty policy to verify our image"

pe "ec validate image --policy '' --public-key cosign.pub --image $IMAGE --output text --ignore-rekor --show-successes"

pei "# Use ec to validate the SLSA Provenance attestations of our image using ec-policies' ruleset"

pe "cat policy.yaml | yq"

pe "ec validate image --policy policy.yaml --image $IMAGE --output text --ignore-rekor --info --show-successes"

pei "# Perform the same check, with report in YAML"

pe "ec validate image --policy policy.yaml --image $IMAGE --output yaml --ignore-rekor --info --show-successes | yq"

pei "# Perform the same validation across multiple image references"

pe "cat components.yaml | yq"

pe "ec validate image --policy policy.yaml --images components.yaml --output text --ignore-rekor --info --show-successes"

pei "# EC has tons of policy rules built in - see them all at https://enterprisecontract.dev/docs/ec-policies/release_policy.html"

pei "# EC isn't limited to Konflux - let's try verifying an image built in Github Actions and signed keylessly with Cosign!"

pe "IMAGE=quay.io/lucarval/festoji:latest"

pe "ec validate image --policy '' --image $IMAGE \
  --certificate-identity-regexp='https:\/\/github\.com\/(slsa-framework\/slsa-github-generator|lcarva\/festoji)\/' \
  --certificate-oidc-issuer='https://token.actions.githubusercontent.com' \
  --output yaml | yq"

pei "# Let's craft a new policy for this image, and verify against it!"

pe "cat policy-github.yaml | yq"

pe "ec validate image --policy policy-github.yaml --image $IMAGE --output yaml --show-successes | yq"

pei "# We can also use this to demonstrate what a policy failure would look like..."

pe "ec validate image --policy policy-github-failing.yaml --image $IMAGE --output text --show-successes --info"

pei "# EC's rules are built with Rego under the hood, and you can craft your own. Let's try that!"

pe "cat policies/github-slsa-provenance.rego"

pei "# Let's add this custom rule to our policy, and then run against it..."

pe "cat policy-github-custom.yaml | yq"

pe "ec validate image --policy policy-github-custom.yaml --image $IMAGE --output text --info --show-successes"
