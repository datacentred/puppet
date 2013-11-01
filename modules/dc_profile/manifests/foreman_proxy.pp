class dc_profile::foreman_proxy {

  realize Dc_repos::Virtual::Repo['local_foreman_mirror']

  package { 'foreman-proxy':
    ensure  => installed,
    require => Dc_repos::Virtual::Repo['local_foreman_mirror'],
    name    => 'foreman-proxy',
  }

}
