#!/bin/bash
# Bootstrap the vagrant puppet clients

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

# Run puppet apply
FACTER_is_vagrant=true puppet apply -e "include ${1}" \
  --modulepath /vagrant/modules:/vagrant/site:/vagrant/dist \
  --hiera_config /vagrant/vagrant/hiera.yaml \
  --environment production \
  --storeconfigs \
  --storeconfigs_backend puppetdb \
  --pluginsync
