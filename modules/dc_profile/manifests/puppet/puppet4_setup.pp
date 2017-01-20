# == Class: dc_profile::puppet::puppet4_setup
#
# Manage the things we take for granted with Puppet 3.x which cease to
# happen with Puppet 4+
#
class dc_profile::puppet::puppet4_setup {

  # Puppetserver has its own special home directory
  if $::role in ['puppet_ca', 'puppet_master'] {
    $_home = '/opt/puppetlabs/server/data/puppetserver'

    # Create the home directory tree (happens post user creation)
    file { '/opt/puppetlabs/server':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    } ->

    file { '/opt/puppetlabs/server/data':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0775',
    } ->

    file { '/opt/puppetlabs/server/data/puppetserver':
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0750',
    }
  } else {
    $_home = undef
  }

  # Create the puppet user/group (puppetserver does this implicitly)
  group { 'puppet':
    ensure => present,
    system => true,
  } ->

  user { 'puppet':
    ensure => present,
    gid    => 'puppet',
    shell  => '/bin/bash',
    system => true,
    home   => $_home,
  } ->

  # Update the private key from root:root 640 to something accessible by the puppet group
  file { "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem":
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0640',
  }

}
