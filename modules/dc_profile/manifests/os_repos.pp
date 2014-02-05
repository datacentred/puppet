# Openstack profile
class dc_profile::os_repos {

  realize Dc_repos::Virtual::Repo['local_cloudarchive_mirror']
  realize Dc_repos::Virtual::Repo['local_mariadb_mirror']

}

