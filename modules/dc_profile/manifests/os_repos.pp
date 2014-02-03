# Openstack profile
class dc_profile::os_repos {

  include dc_repos::repolist

  Dc_repos::Virtual::Repo <| tag == openstack |>

}

