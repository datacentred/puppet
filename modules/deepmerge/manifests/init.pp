# == Class: deepmerge
#
# Installs the deepmerge gem for ruby environments
#
# === Notes
#
# With puppet 4 we should be able to use hash.map to do this
# generically for an arbitrary set of version controlled gems
#
class deepmerge {

  package { 'deep_merge':
    ensure   => installed,
    provider => gem,
  }

}
