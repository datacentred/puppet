# Class: dc_puppet::master::deep_merge
#
# Dependencies for deep merging in hiera
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::deep_merge {

  ensure_packages(['rubygems'])

  package { 'deep_merge':
    ensure   => installed,
    provider => gem,
    require  => Package['rubygems'],
  }

}
