# Google Coral Development Environment

This project provides a containerized development environment for Google Coral projects, packaged as a Docker image and designed to work with Apptainer.

## Overview

The container includes all necessary tools and dependencies for Coral development, including Bazel build system and other development utilities.

## Basic Usage

1. **Run a command in the container:**

```bash
./coral-env bazel build //tests/cocotb:all
```

2. **Run with custom workspace directory:**

```bash
./coral-env -w /path/to/your/project bazel build :target
```

3. **Set workspace via environment variable:**

```bash
export CORAL_WORKSPACE_DIR=/path/to/your/project
./coral-env bazel build :target
```

4. **Pull the latest container and run command:**

```bash
./coral-env --pull bazel version
```

5. **Open an interactive shell inside container:**

```bash
./coral-env /bin/bash
```

## coral-env Script

The `coral-env` wrapper script simplifies running commands in the Apptainer container by automatically handling:

- Container pulling from Docker Hub
- Workspace directory binding
- Build output directory management
- Consistent working directory setup

### Command Line Options

- `-h, --help`: Show help message
- `-p, --pull`: Pull/update the container from Docker Hub before running program inside container
- `-w, --workspace DIR`: Set workspace directory (default: current directory or `$CORAL_WORKSPACE_DIR`)

### Environment Variables

- `CORAL_WORKSPACE_DIR`: Default workspace directory to mount into the container

### Examples

**Executing binaries:**

```bash
./coral-env bazel-bin/tests/verilator_sim/core_mini_axi_sim \
    --binary bazel-out/k8-fastbuild-ST-dd8dc713f32d/bin/examples/coralnpu_v2_hello_world_add_floats.elf \
    --instr_trace
```

**Running Bazel with custom output root:**

```bash
./coral-env bazel --output_user_root=/tmp/build_output_coral_env run //tests/cocotb:core_mini_axi_sim_cocotb
```

## Container Details

### Mounted Directories

The `coral-env` script automatically mounts:

1. **Workspace directory** → `/src/workspace` (inside container)
   - Default: Current directory
   - Override: Use `-w` flag or `CORAL_WORKSPACE_DIR` environment variable

2. **Build output** → `/tmp/build_output_coral_env`
   - Persists build artifacts between container runs
   - Improves build performance

## Publishing to Docker Hub

The container is automatically built and published to Docker Hub when you push a tagged commit.

### Creating a Release

To build and publish a new version:

```bash
# Create and push a tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

The GitHub Action will automatically:
1. Build the Docker image
2. Tag it with the version number (e.g., `v1.0.0`)
3. Tag it as `latest`
4. Push both tags to Docker Hub

### Version Tags

Each release creates two Docker tags:
- Version tag: `your-username/coral-env:v1.0.0`
- Latest tag: `your-username/coral-env:latest`

Users can pull a specific version:
```bash
apptainer pull coral-env.sif docker://your-username/coral-env:v1.0.0
```

Or always get the latest:
```bash
apptainer pull coral-env.sif docker://your-username/coral-env:latest
```