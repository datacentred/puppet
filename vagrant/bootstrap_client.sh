#!/bin/bash
# Bootstrap the vagrant puppet clients

# Exit if the following file exists
test -f /root/.provisioned && exit 0

DEBIAN_PACKAGES='puppetdb-terminus bundler'
RHEL_PACKAGES='puppetdb-terminus rubygem-bundler'

# By default the puppet VMs have vagrant at 1000:1000 which interferes with
# our hard coded IDs.  Removing this hurdle allows testing of user account
# provisioning
userdel -rf vagrant

# Distribution-specific package considerations
if [ -f /etc/redhat-release ]; then
  yum update -y >/dev/null
  yum makecache fast >/dev/null
  for package in ${RHEL_PACKAGES}; do
    yum install -y ${package} > /dev/null
  done
  sed -i '/Defaults    requiretty/d' /etc/sudoers
else
  apt-get update &> /dev/null
  for package in ${DEBIAN_PACKAGES}; do
    dpkg -s ${i} &> /dev/null || apt-get -y install ${package} > /dev/null
  done
fi

# Install gems
bundle install --gemfile /vagrant/vagrant/Gemfile

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
