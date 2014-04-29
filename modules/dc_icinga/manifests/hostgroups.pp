#
class dc_icinga::hostgroups {

  @dc_external_facts::fact { 'dc_hostgroup_http': }
  @dc_external_facts::fact { 'dc_hostgroup_https': }
  @dc_external_facts::fact { 'dc_hostgroup_puppetmaster': }
  @dc_external_facts::fact { 'dc_hostgroup_postgres': }
  @dc_external_facts::fact { 'dc_hostgroup_dhcp': }
  @dc_external_facts::fact { 'dc_hostgroup_tftp': }
  @dc_external_facts::fact { 'dc_hostgroup_dns': }
  @dc_external_facts::fact { 'dc_hostgroup_ntp': }
  @dc_external_facts::fact { 'dc_hostgroup_puppetdb': }
  @dc_external_facts::fact { 'dc_hostgroup_foreman_proxy': }
  @dc_external_facts::fact { 'dc_hostgroup_mysql': }
  @dc_external_facts::fact { 'dc_hostgroup_logstashes': }
  @dc_external_facts::fact { 'dc_hostgroup_keystone': }
  @dc_external_facts::fact { 'dc_hostgroup_nfs': }
  @dc_external_facts::fact { 'dc_hostgroup_foreman': }
  @dc_external_facts::fact { 'dc_hostgroup_smtp': }
  @dc_external_facts::fact { 'dc_hostgroup_postfix': }
  @dc_external_facts::fact { 'dc_hostgroup_nova_compute': }
  @dc_external_facts::fact { 'dc_hostgroup_neutron_node': }
  @dc_external_facts::fact { 'dc_hostgroup_neutron_server': }
  @dc_external_facts::fact { 'dc_hostgroup_nova_server': }

}
