# Class: dc_profile::apt::dpkg
#
# Ensure dpkg is configuired correctly
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::apt::dpkg {

  # Remove multiarch support
  if $::lsbdistcodename == 'precise' {
    file { '/etc/dpkg/dpkg.cfg.d/multiarch':
      ensure => absent,
    }
  }
  elsif $::lsbdistcodename == 'trusty' {
    file {'/var/lib/dpkg/arch':
      ensure  => file,
      content => 'amd64\n',
    }
  }
}
