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

    $packages = [
      'iptables-persistent',
      'php7.0-snmp',
      'php7.0-cli',
      'snmp-mibs-downloader',
      'snmp',
    ]

    ensure_packages($packages)

    if $firewall_enabled {
      if hiera('firewall::purge') {
          resources { 'firewall': purge => true }
      }
      create_resources(firewall, $firewall_rules['base'])
      create_resources(firewall, $firewall_rules['proxy'])
    }

    user { 'zabbix':
      ensure  => present,
      groups  => ['puppet'],
      require => Package['zabbix-proxy-pgsql'],
    }

    file { '/usr/share/mibs/ietf/SNMPv2-PDU':
      ensure => absent,
    }

    file { '/usr/share/mibs/ietf/IPATM-IPMC-MIB':
      ensure => absent,
    }

    file { '/usr/share/mibs/iana/IANA-IPPM-METRICS-REGISTRY-MIB':
      ensure => absent,
    }

    file { '/etc/snmp/snmp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/dc_zabbix/snmp.conf',
      require => Package['snmp'],
    }

    file { '/usr/lib/zabbix/externalscripts/jnxBgpM2Peer':
      ensure  => file,
      require => Package['zabbix-proxy-pgsql'],
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => 'puppet:///modules/dc_zabbix/jnxBgpM2Peer',
    }

}
