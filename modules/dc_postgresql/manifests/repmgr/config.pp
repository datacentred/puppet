class dc_postgresql::repmgr::config {

  include ::passwordless_ssh
  include ::dc_postgresql::params

  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::repmgr::config']

  passwordless_ssh { 'postgres':
    ssh_private_key => $dc_postgresql::params::ssh_private_key,
    ssh_public_key  => $dc_postgresql::params::ssh_public_key,
    home            => $dc_postgresql::params::pghome,
  }

  $node_id = $dc_postgresql::params::nodemap[$::hostname]

  file { "${dc_postgresql::params::pghome}/repmgr":
    ensure  => directory,
  }

  file { "${dc_postgresql::params::pghome}/repmgr/repmgr.conf":
    ensure  => file,
    content => template('dc_postgresql/repmgr.conf.erb'),
  }

}
