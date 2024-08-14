# ec-cli-demo
A quick demo of the Enterprise Contract CLI, based on the [intro blog post](https://enterprisecontract.dev/posts/introducing-the-enterprise-contract/).

## Requirements

This demo requires:

- [demo-magic](https://github.com/paxtonhare/demo-magic), installed at `~/.bin/demo-magic.sh`:
- `skopeo`: `dnf install skopeo`
- `cosign`: install with go using `go install github.com/sigstore/cosign/v2/cmd/cosign@v2.0.2`
- `ec-cli`: build from source or install manually from [releases](https://github.com/enterprise-contract/ec-cli)

To install from a release: download the correct binary, run `chmod +x <binary>`, then move to a location on path, ex. `/usr/bin`.
