# == Class: dc_profile::puppet::puppet4_setup
#
# Manage the things we take for granted with Puppet 3.x which cease to
# happen with Puppet 4+
#
class dc_profile::puppet::puppet4_setup {

  # Create the puppet user/group (puppetserver does this implicitly)
  group { 'puppet':
    ensure => present,
    system => true,
  } ->

  # Update the private key from root:root 640 to something accessible by the puppet group
  file { "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem":
    ensure => file,
    owner  => 'root',
    group  => 'puppet',
    mode   => '0640',
  }

}
