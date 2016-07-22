class dc_postgresql::repmgr::master::configure {

  $_conf = "${::dc_postgresql::repmgr::home}/repmgr.conf"

  runonce { 'register_master_repmgr':
    command => "repmgr -f ${_conf} --verbose master register",
    user    => 'postgres',
  }

}
