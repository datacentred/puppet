class dc_profile::net::zabbix_proxy {

    include ::postgresql::server

    class { 'zabbix::proxy':
      zabbix_server_host => $_zabbix_url,
      database_type      => $_database_type,
    }

    Class['postgresql::server'] -> Class['zabbix::proxy']
}
