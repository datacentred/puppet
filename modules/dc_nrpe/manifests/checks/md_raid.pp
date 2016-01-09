# == Class: dc_nrpe::checks::md_raid
#
class dc_nrpe::checks::md_raid {

  dc_nrpe::check { 'check_md_raid':
    path => '/usr/lib/nagios/plugins/check_md_raid.sh',
  }

}
