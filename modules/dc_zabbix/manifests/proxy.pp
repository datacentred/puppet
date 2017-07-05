# Class: dc_zabbix::proxy
#
# Deploys a zabbix 3 proxy and agent
#
class dc_zabbix::proxy (
  $firewall_rules = $dc_zabbix::params::firewall_rules,
  $firewall_enabled = $dc_zabbix::params::firewall_enabled,
) inherits ::dc_zabbix::params
{

    include ::postgresql::server
    include ::firewall
    include ::zabbix::proxy
    include ::zabbix::agent

    ensure_packages('iptables-persistent')

    if $firewall_enabled {
      if hiera('firewall::purge') {
          resources { 'firewall': purge => true }
      }
      create_resources(firewall, $firewall_rules['base'])
      create_resources(firewall, $firewall_rules['proxy'])
    }

    user { 'zabbix':
      ensure  => present,
      groups  => [puppet],
      require => Package['zabbix-proxy-pgsql'],
    }
}
