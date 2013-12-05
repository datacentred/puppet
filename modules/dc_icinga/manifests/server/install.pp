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

  # Core bit that goes probing the hosts
  package { 'icinga-core':
    ensure => present,
  }

  # Sadly icinga-web isn't avaiable in LTS yet *sigh*
  package { 'icinga-cgi':
    ensure => present,
  }

}
