FROM gcr.io/bazel-public/bazel:7.4.1

# Install srecord and common utilities you may need
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends srecord ca-certificates && \
    rm -rf /var/lib/apt/lists/*
