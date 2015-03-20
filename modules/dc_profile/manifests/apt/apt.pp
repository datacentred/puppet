# Class: dc_profile::apt::apt
#
# Apt configuration, ensures default sources are
# removed and unmanaged files in sources.list.d
# are also removed
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

  contain ::dpkg
  contain ::apt
  contain ::apt::unattended_upgrades
  contain ::dc_apt

  # Ensure supported architectures are set up before apt updates
  Class['::dpkg'] -> Class['::apt']

  # Ensure an apt-get update happens before any package installs
  Class['apt::update'] -> Package <| |>

}
