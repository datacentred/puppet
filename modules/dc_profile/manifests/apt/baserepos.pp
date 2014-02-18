# Class: dc_profile::apt::baserepos
#
# Common repositories
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::apt::baserepos {

  contain dc_profile::apt::dpkg
  include dc_repos::repolist

  class { 'apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }

  Dc_repos::Repo <| tag == baserepos |>

}

