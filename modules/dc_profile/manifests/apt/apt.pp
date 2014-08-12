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

  class { '::apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }
  contain 'apt'

  # Ensure an apt-get update happens before any package installs
  Package <| |> <- Class['apt::update']

}
