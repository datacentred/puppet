# == Class: dc_nrpe::postgres
#
class dc_nrpe::postgres {

  dc_nrpe::check { 'check_postgres_replication':
    path    => '/usr/local/bin/check_postgres_replication',
    content => template('dc_nrpe/check_postgres_replication.erb'),
    sudo    => true,
  }

}
