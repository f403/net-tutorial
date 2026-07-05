# Containerlab Images

This repository contains custom Docker images used by the containerlab deployment in `../ans-deploy-clabs-vm/`.

## Structure

Each image lives in its own subdirectory. The current image is:

- `ubuntu/` - Ubuntu-based lab node image.

Every image directory must contain:

- `Dockerfile` - image build definition.
- `config.sh` - image parameters consumed by helper scripts.

Current `ubuntu/config.sh`:

```bash
IMAGE_TAG="clabs-ubuntu:2026-06-03"
```

## Commands

Build an image:

```bash
./build.sh ubuntu
```

Save an image archive for deployment:

```bash
./save.sh ubuntu
```

The archive is written to `.tmp/` using the image tag with path separators replaced by underscores. For the current Ubuntu image this produces:

```text
.tmp/clabs-ubuntu_2026-06-03.tar.gz
```

## Deployment Link

The deployment repository loads image archives through `lab_image_archives` in `../ans-deploy-clabs-vm/vars.yaml`. Lab topology templates must reference the exact tag from `config.sh`, for example:

```yaml
image: clabs-ubuntu:2026-06-03
```

When changing `IMAGE_TAG`, update the deployment repo archive URL and all lab templates that use the image.
