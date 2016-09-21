# Class: dc_profile::net::network_monitoring_satellite.pp
#
# Deploys a Zabbix 3 proxy and agent.
#
# Parameters:
#
# Actions:
#
# Requires:

#Sample Usage:
class dc_profile::net::network_monitoring_satellite {

    include ::postgresql::server
    include ::zabbix::proxy
    include ::zabbix::agent

    ensure_packages('iptables-persistent')
}
