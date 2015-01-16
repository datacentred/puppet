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
  contain ::apt

  # We've enabled the trusty-proposed repo, but let's not
  # automatically pull in packages from there
  apt::pin { 'trusty-proposed':
    packages => '*',
    release  => 'trusty-proposed',
    priority => '400',
  }

  # Disable automatic updates and downloads
  contain ::apt::unattended_upgrades

  # Ensure an apt-get update happens before any package installs
  Class['apt::update'] -> Package <| |>
}
