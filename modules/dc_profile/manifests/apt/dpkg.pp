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
    exec { 'remove-architecture i386':
        command => '/usr/bin/dpkg --remove-architecture i386',
        onlyif  => '/usr/bin/dpkg --print-foreign-architectures | /bin/grep -q i386',
    }
  }
}

