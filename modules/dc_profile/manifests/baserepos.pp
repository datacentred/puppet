#
class dc_profile::baserepos {

  contain dc_profile::dpkg
  include dc_repos::repolist

  class { 'apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
  }

  Dc_repos::Repo <| tag == baserepos |>

}

