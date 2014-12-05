class dc_postgresql::repmgr::config {

  include ::dc_postgresql::params

  Class['::dc_postgresql::install'] ->
  Class['::dc_postgresql::repmgr::config']

  $node_id = $dc_postgresql::params::nodemap[$::hostname]

  file { "${dc_postgresql::params::pghome}/repmgr":
    ensure  => directory,
  }

  file { "${dc_postgresql::params::pghome}/repmgr/repmgr.conf":
    ensure  => file,
    content => template('dc_postgresql/repmgr.conf.erb'),
  }

}
