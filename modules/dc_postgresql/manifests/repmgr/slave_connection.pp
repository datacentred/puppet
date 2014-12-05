class dc_postgresql::repmgr::slave_connection {

  Postgresql::Server::Pg_hba_rule <<| tag == 'slave' |>>

}
