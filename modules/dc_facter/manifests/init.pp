# Class: dc_facter
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_facter {

  file { '/usr/lib/ruby/vendor_ruby/facter':
    ensure  => directory,
    source  => 'puppet:///modules/dc_facter',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => false,
    recurse => 'remote',
  }

}
