#!/usr/bin/env bash

########################
# include the magic
########################
. ~/bin/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

pei "# resolve image reference to digest"

pe "skopeo inspect --no-tags docker://quay.io/lucarval/demo:ec | jq '.Digest'"

pe "IMAGE='quay.io/lucarval/demo:ec@sha256:304040ca1911aa4d911bd7c6d6d07193c57dc49dbc43e63828b42ab204fb1b25'"

pe "cat cosign.pub"

pe "cosign verify --key cosign.pub $IMAGE --insecure-ignore-tlog"

pei "# Verify SLSA attestations"

pe "cosign verify-attestation --type slsaprovenance --key cosign.pub $IMAGE --insecure-ignore-tlog | jq"

pe "# Use ec with an empty policy"

pe "ec validate image --policy '' --rekor-url '' --public-key cosign.pub --image $IMAGE --output yaml | yq"

pe "# Use ec to validate the SLSA Provenance attestations using ec-policies' ruleset"

pe "cat policy.yaml | yq"

pe "ec validate image --policy policy.yaml --image $IMAGE --output yaml --info | yq"
