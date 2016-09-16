class dc_profile::net::zabbix_proxy {

    include ::mysql::server

    class { 'zabbix::proxy':
      zabbix_server_host => $_zabbix_url,
      database_type      => $_database_type,
    }
}
