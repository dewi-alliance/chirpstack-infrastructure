#! /bin/bash

# Update and upgrade the package list
apt-get update -y
apt-get upgrade -y

# Install deps
apt-get -y build-essential pkg-config libssl-dev tcl libjemalloc-dev wget

# Install PostgreSQL client
apt-get install -y postgresql-client

# Install Redis CLI
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make distclean
make BUILD_TLS=yes
cp src/redis-cli /usr/bin/redis-cli

# Verify installation
psql --version
redis-cli --version
