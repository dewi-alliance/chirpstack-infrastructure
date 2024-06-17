#! /bin/bash

echo "Update and Upgrade Packages"
apt-get update -y
apt-get upgrade -y

echo "Install Dependencies"
apt-get install -y build-essential pkg-config libssl-dev tcl libjemalloc-dev wget

echo "Install PostgreSQL Client"
apt-get install -y postgresql-client

echo "Install Redis CLI"
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make distclean
make BUILD_TLS=yes
cp /tmp/redis-stable/src/redis-cli /usr/bin/redis-cli

echo "Verify Installation"
psql --version
redis-cli --version
