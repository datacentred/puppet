# Install collectd from a local mirror of the project's repo
#
class dc_collectd::install {

  include dc_repos::repolist
  realize (Dc_repos::Virtual::Repo['local_collectd_mirror'])

  class { '::collectd':
    require      => Dc_repos::Virtual::Repo['local_collectd_mirror'],
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  contain 'collectd'

}
