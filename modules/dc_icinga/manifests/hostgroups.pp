#
class dc_icinga::hostgroups {

  @external_facts::fact { 'dc_hostgroup_http': }
  @external_facts::fact { 'dc_hostgroup_https': }
  @external_facts::fact { 'dc_hostgroup_puppetmaster': }
  @external_facts::fact { 'dc_hostgroup_postgres': }
  @external_facts::fact { 'dc_hostgroup_dhcp': }
  @external_facts::fact { 'dc_hostgroup_tftp': }
  @external_facts::fact { 'dc_hostgroup_dns': }
  @external_facts::fact { 'dc_hostgroup_ntp': }
  @external_facts::fact { 'dc_hostgroup_puppetdb': }
  @external_facts::fact { 'dc_hostgroup_foreman_proxy': }
  @external_facts::fact { 'dc_hostgroup_mysql': }
  @external_facts::fact { 'dc_hostgroup_logstashes': }
  @external_facts::fact { 'dc_hostgroup_keystone': }
  @external_facts::fact { 'dc_hostgroup_nfs': }
  @external_facts::fact { 'dc_hostgroup_foreman': }
  @external_facts::fact { 'dc_hostgroup_smtp': }
  @external_facts::fact { 'dc_hostgroup_postfix': }
  @external_facts::fact { 'dc_hostgroup_nova_compute': }
  @external_facts::fact { 'dc_hostgroup_neutron_node': }
  @external_facts::fact { 'dc_hostgroup_neutron_server': }
  @external_facts::fact { 'dc_hostgroup_nova_server': }
  @external_facts::fact { 'dc_hostgroup_rabbitmq': }
  @external_facts::fact { 'dc_hostgroup_glance': }
  @external_facts::fact { 'dc_hostgroup_ldap': }
  @external_facts::fact { 'dc_hostgroup_cinder': }

}
