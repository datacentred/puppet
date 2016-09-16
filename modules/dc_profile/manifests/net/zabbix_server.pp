class dc_profile::net::zabbix_server {

    include ::apache 
    include ::apache::mod::php
    include ::postgresql::server

    class { 'zabbix':
      zabbix_url    => $_zabbix_url,
      database_type => $_database_type,
    }

    Class['apache'] -> Class['postgresql::server'] -> Class['zabbix']
}
