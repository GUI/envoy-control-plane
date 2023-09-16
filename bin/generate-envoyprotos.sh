#! /usr/bin/env bash

# Generate imports for all the possible Envoy types and extensions needed:
# https://github.com/envoyproxy/go-control-plane/issues/390
# https://github.com/jpeach/envoy-controller/blob/master/hack/generate-envoyprotos.sh

set -o pipefail
set -o nounset
set -o errexit

readonly HERE=$(cd $(dirname "$0") && pwd)
readonly REPO=$(cd "${HERE}/.." && pwd)

exec > ${REPO}/register.go

(
	echo package main

	cat <<EOF
// Import all the Envoy API packages from go-control-plane for their
// side-effects. This causes all their protobuf types to be registered.

// The import list can be generated with the following script:
//
// $0
EOF

	echo "import ("

	go list -mod=readonly github.com/envoyproxy/go-control-plane/envoy/...  |
		sort | \
		awk '{printf "_ \"%s\"\n", $1}'

	echo ")"
) | gofmt
