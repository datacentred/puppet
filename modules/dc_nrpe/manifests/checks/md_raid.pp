# == Class: dc_nrpe::checks::md_raid
#
class dc_nrpe::checks::md_raid {

  dc_nrpe::check { 'check_md_raid':
    source => 'puppet:///modules/dc_nrpe/check_md_raid.sh',
    path   => '/usr/local/bin/check_md_raid.sh',
  }

}
