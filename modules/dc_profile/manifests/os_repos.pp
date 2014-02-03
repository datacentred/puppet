# Openstack profile
class dc_profile::os_repos {

  include dc_repos::repolist

  realize Dc_repos::Virtual::Repo['local_cloudarchive_mirror']

}

