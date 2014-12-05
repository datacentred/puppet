class dc_postgresql::repmgr::master::config {

  include ::dc_postgresql::params

  runonce { 'register_master_repmgr':
    command => "repmgr -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose master register",
    require => [
      Class['::dc_postgresql::repmgr::db'],
      Class['::dc_postgresql::repmgr::local_connection'],
      Class['::dc_postgresql::repmgr::config'],
    ],
  }

}
