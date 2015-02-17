#!/bin/bash
# Bootstrap the vagrant puppet clients

# Exit if the following file exists
test -f /root/.provisioned && exit 0

# Ensure we've got the latest APT caches
apt-get update &> /dev/null

# Ensure we have the required packages installed
for i in puppetdb-terminus; do
  dpkg -s ${i} &> /dev/null || apt-get -y install ${i} > /dev/null
done

# Ensure we have the required rubygems installed
for i in hiera-eyaml; do
  gem query --name ${i} --installed &> /dev/null || gem install --no-rdoc --no-ri ${i} > /dev/null
done

# Setup PuppetDB
cat << EOF > /etc/puppet/puppetdb.conf
[main]
server = puppetdb.$(hostname -d)
EOF

# Set up routes.yaml to ensure facts are up to date
cat <<EOF > /etc/puppet/routes.yaml
---
apply:
  catalog:
    terminus: compiler
    cache: puppetdb
  facts:
    terminus: facter
    cache: puppetdb_apply
EOF

# Clean out stale SSL certificates
find /var/lib/puppet/ssl -type f -delete

# Done provisioning
touch /root/.provisioned
