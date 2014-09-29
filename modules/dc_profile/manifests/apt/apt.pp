# Class: dc_profile::apt::apt
#
# Apt configuration, ensures default sources are
# removed and unmanagaed files in sources.list.d
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

  # Ensure an apt-get update happens before any package installs
  Class['apt::update'] -> Package <| |>
}
