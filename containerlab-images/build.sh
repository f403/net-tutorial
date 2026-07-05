#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 IMAGE_SUBDIR" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage

image_subdir="$1"
case "$image_subdir" in
  ""|.*|*/*) usage ;;
esac

image_dir="$repo_dir/$image_subdir"
config_file="$image_dir/config.sh"
dockerfile="$image_dir/Dockerfile"

[[ -d "$image_dir" ]] || { echo "Image directory not found: $image_subdir" >&2; exit 1; }
[[ -f "$config_file" ]] || { echo "Missing config: $config_file" >&2; exit 1; }
[[ -f "$dockerfile" ]] || { echo "Missing Dockerfile: $dockerfile" >&2; exit 1; }

# shellcheck disable=SC1090
source "$config_file"

[[ -n "${IMAGE_TAG:-}" ]] || { echo "IMAGE_TAG is not set in $config_file" >&2; exit 1; }

docker build -t "$IMAGE_TAG" "$image_dir"
