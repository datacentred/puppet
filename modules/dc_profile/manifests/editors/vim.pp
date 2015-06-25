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

  $vim_package = $::operatingsystem ? {
    /(RedHat|CentOS)/ => 'vim-common',
    /(Debian|Ubuntu)/ => 'vim',
  }

  ensure_packages($vim_package)

}
