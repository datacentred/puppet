# Class:
#
# Apt configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::apt::apt {

  class { '::apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }
  contain 'apt'

}

