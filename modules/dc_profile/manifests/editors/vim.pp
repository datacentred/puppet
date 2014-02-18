# Class: dc_profile::editors::vim
#
# Installs and configures Vi Improved
# Hail Uganda!!
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::editors::vim {

  package { 'vim' :
    ensure => installed,
  }

}
