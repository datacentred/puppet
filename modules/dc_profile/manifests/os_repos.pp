# Openstack profile
class dc_profile::os_repos {

  realize Dc_repos::Repo['local_cloudarchive_mirror']
  realize Dc_repos::Repo['local_mariadb_mirror']

}

