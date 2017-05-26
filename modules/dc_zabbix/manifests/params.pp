# == Class: dc_zabbix::params
#
# Defines platform specific default configuration parameters
#
class dc_zabbix::params {

  $zabbix_url = 'monitoring.datacentred.net'
  $apache_php_max_execution_time = '300'
  $apache_php_memory_limit = '128M'
  $apache_php_post_max_size = '16M'
  $apache_php_upload_max_filesize = '2M'
  $apache_php_max_input_time = '300'
  $apache_php_always_populate_raw_post_data = '-1'
  $apache_php_max_input_vars = '1000'
  $apache_php_date_time = 'Europe/London'
  $firewall_enabled = true

  $firewall_rules = {
    'base'                                  => {
      '000 INPUT allow related'             => { chain => 'INPUT', state  => [ 'RELATED', 'ESTABLISHED' ], proto => 'all', action                    => 'accept' },
      '001 accept lo'                       => { chain => 'INPUT', proto  => 'all', iniface                      => 'lo', action                     => 'accept' },
      '002 accept all icmp'                 => { chain => 'INPUT', proto  => 'icmp', action                      => 'accept' },
      '003 allow ssh access'                => { chain => 'INPUT', proto  => 'tcp', dport                        => '22', action                     => 'accept' },
      '999 deny all other input requests'   => { chain => 'INPUT', proto  => 'all', action                       => 'drop' }
    },
    'server' => {
      '004 allow zabbix'                    => { chain => 'INPUT', proto  => 'tcp', dport                        => [ '10051', '443', '80' ], action => 'accept' },
    }
  }
}
