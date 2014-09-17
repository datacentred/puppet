# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update

# Install puppet/facter
apt-get install -y puppet facter
