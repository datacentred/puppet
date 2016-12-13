#!/bin/bash
# Bootstrap the vagrant puppet clients

# Exit if the following file exists
test -f /root/.provisioned && exit 0

source /etc/lsb-release

################################################################################
# Configuration
################################################################################

PACKAGES='puppet-agent puppetdb-termini git software-properties-common'

PUPPET_GEMS='deep_merge hiera-eyaml toml'

################################################################################
# Configure users
################################################################################

# By default the puppet VMs have vagrant at 1000:1000 which interferes with
# our hard coded IDs.  Removing this hurdle allows testing of user account
# provisioning
userdel -rf vagrant

################################################################################
# Install packages
################################################################################

wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb
dpkg -i puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb
apt-get update
for package in $PACKAGES; do
  apt-get install -y $package
done
for gem in $PUPPET_GEMS; do
  /opt/puppetlabs/puppet/bin/gem install $gem
done

################################################################################
# Configure puppet-agent
################################################################################

# Configure storeconfigs
cat << EOF > /etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://puppet.$(hostname -d):8081
EOF

# Set up routes.yaml to ensure facts are up to date
cat <<EOF > /etc/puppetlabs/puppet/routes.yaml
---
apply:
  catalog:
    terminus: compiler
    cache: puppetdb
  facts:
    terminus: facter
    cache: puppetdb_apply
EOF

# Generate certificates and keys
/opt/puppetlabs/bin/puppet agent --test

################################################################################
# VMware hacks
################################################################################

if [ -d /etc/vmware-tools ]; then
  echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations
fi

# Done provisioning
touch /root/.provisioned
