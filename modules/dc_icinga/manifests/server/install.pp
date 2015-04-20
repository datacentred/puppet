# Class:
#
# Installs icinga for Ubuntu 12.04 and the legacy web interface
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::install {

  package { 'python-tftpy':
    ensure => present,
  }

  package { 'nfs-common':
    ensure => present,
  }

  # Fix the RPC check, easiest way is to symlink
  file { '/usr/bin/rpcinfo':
    ensure  => link,
    target  => '/usr/sbin/rpcinfo',
    require => Package['nfs-common'],
  }

  package { 'libwww-perl':
    ensure => present,
  }

  package { 'libjson-perl':
    ensure => present,
  }

  # RabbitMQ plugins need libnagios-plugin-perl
  package { 'libnagios-plugin-perl':
    ensure => latest,
  }

  # Python packages for Openstack checks
  package { 'python-keystoneclient':
    ensure => installed,
  }

  package { 'python-neutronclient':
    ensure => installed,
  }

  package { 'python-novaclient':
    ensure => installed,
  }

  package { 'python-cinderclient':
    ensure => installed,
  }

  package { 'curl':
    ensure => installed,
  }

  package { 'bc':
    ensure => installed,
  }

  # MongoDB needs pymongo
  package { 'python-pymongo':
    ensure => installed,
  }

  # Packages for Postgresql checks

  package { 'postgresql-client':
    ensure => installed,
  }

  package { 'python-psycopg2':
    ensure => installed,
  }

  package { 'nagiosplugin':
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  # memcached checks need an additional Perl module
  package { 'libcache-memcached-perl':
    ensure => installed
  }

}
