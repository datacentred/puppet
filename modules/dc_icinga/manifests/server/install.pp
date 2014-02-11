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

  # Make sure we use our back port as there is a bug with LTS
  # version of icinga-core that can cause fiery death
  include dc_repos::repolist
  realize(Dc_repos::Virtual::Repo['local_datacentred_backports'])

  # So we can probe others
  package { 'nagios-nrpe-plugin':
    ensure  => present,
  }

  # Core bit that goes probing the hosts
  package { 'icinga-core':
    ensure  => present,
    require => Dc_repos::Virtual::Repo['local_datacentred_backports'],
  }

  # Sadly icinga-web isn't avaiable in LTS yet *sigh*
  package { 'icinga-cgi':
    ensure  => present,
    require => Dc_repos::Virtual::Repo['local_datacentred_backports'],
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

}
