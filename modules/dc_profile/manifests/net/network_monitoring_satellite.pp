# Class: dc_profile::net::network_monitoring_satellite
#
# Deploys a Zabbix 3 proxy and agent.
#
class dc_profile::net::network_monitoring_satellite {

    include ::dc_zabbix::proxy

}
