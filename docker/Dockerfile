# Python Reference Information:
# https://pmac.io/2019/02/multi-stage-dockerfile-and-python-virtualenv/
# I haven't worked very much with R and
# fortunately I haven't had to do much with Python2 but this should meet what was requested.

# Build stage
FROM debian:bullseye-slim AS builder

# Set up virtual environment
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
# Sets utf-8 encoding for Python et al
ENV LANG=C.UTF-8
# Turns off writing .pyc files; superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1
# Ensures that the python and pip executables used
# in the image will be those from our virtualenv.
ENV PATH="/venv/bin:$PATH"

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends\
    software-properties-common \
    curl \
    wget \
    gnupg2 \
    python2 \
    python2-dev \
    python3-dev \
    python3-pip \
    python3-venv \
    gfortran \
    build-essential \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Setup the virtual environments
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && python2 get-pip.py && rm -f get-pip.py \
    && python2 -m pip install virtualenv
RUN python3 -m venv /venv
RUN python2 -m virtualenv /venv2

# Copy and install requirements for both Python versions
COPY requirements.txt requirements-py2.txt ./
RUN . /venv/bin/activate && pip install --no-cache-dir -r requirements.txt
RUN . /venv2/bin/activate && \
    pip install --no-cache-dir -r requirements-py2.txt

# Runtime stage
FROM debian:bullseye-slim

# Reused From Above
ENV DEBIAN_FRONTEND=noninteractive 
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="/venv/bin:/venv2/bin:$PATH"

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    python2 \
    python3 \
    python3-venv \
    r-base \
    libblas3 \
    liblapack3 \
    libatlas3-base \
    && rm -rf /var/lib/apt/lists/*

# copy in Python environments
COPY --from=builder /venv /venv
COPY --from=builder /venv2 /venv2

WORKDIR /app

# Keep container running for k8s
CMD ["tail", "-f", "/dev/null"] 