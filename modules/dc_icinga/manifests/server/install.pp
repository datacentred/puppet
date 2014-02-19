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

  # So we can probe others
  package { 'nagios-nrpe-plugin':
    ensure  => present,
  }

  # Core bit that goes probing the hosts
  package { 'icinga-core':
    ensure  => present,
  }

  # Sadly icinga-web isn't avaiable in LTS yet *sigh*
  package { 'icinga-cgi':
    ensure  => present,
  }

  package { 'python-tftpy':
    ensure => present,
  }

  package { 'python-keystoneclient':
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

}
