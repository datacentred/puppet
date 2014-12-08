class dc_postgresql::repmgr::master::config {

  include ::dc_postgresql::params

  runonce { 'register_master_repmgr':
    command => "repmgr -f ${dc_postgresql::params::pghome}/repmgr/repmgr.conf --verbose master register",
  }

}
