# Class:
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
  file { '/etc/dpkg/dpkg.cfg.d/multiarch':
    ensure => absent,
  }

}

