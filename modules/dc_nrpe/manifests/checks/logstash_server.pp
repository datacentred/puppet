# == Class: dc_nrpe::checks::logstash_server
#
# Checks that log stash is sending data
#
# TODO: Apparently it alerts on an idle cluster, which is annoying
# for the on call engineer
#
class dc_nrpe::checks::logstash_server {

  dc_nrpe::check { 'check_logstashes':
    path   => '/usr/local/bin/es_data_updating_check',
    source => 'puppet:///modules/dc_nrpe/es_data_updating_check',
  }

}
