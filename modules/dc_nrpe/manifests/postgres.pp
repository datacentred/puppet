# == Class: dc_nrpe::postgres
#
class dc_nrpe::postgres (
  $postgres_password, 
){

  dc_nrpe::check { 'check_postgres_replication':
    path    => '/usr/local/bin/check_postgres_replication',
    content => template('dc_nrpe/check_pg_streaming_replication.erb'),
    sudo    => true,
  }

}
