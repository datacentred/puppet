#
class dc_icinga::hostgroups {

  include dc_external_facts::fact

  @dc_external_facts::fact::def { 'dc_hostgroup_http': }
  @dc_external_facts::fact::def { 'dc_hostgroup_https': }
  @dc_external_facts::fact::def { 'dc_hostgroup_puppetmaster': }
  @dc_external_facts::fact::def { 'dc_hostgroup_postgres': }
  @dc_external_facts::fact::def { 'dc_hostgroup_dhcp': }
  @dc_external_facts::fact::def { 'dc_hostgroup_tftp': }
  @dc_external_facts::fact::def { 'dc_hostgroup_dns': }
  @dc_external_facts::fact::def { 'dc_hostgroup_ntp': }
  @dc_external_facts::fact::def { 'dc_hostgroup_puppetdb': }
  @dc_external_facts::fact::def { 'dc_hostgroup_foreman_proxy': }
  @dc_external_facts::fact::def { 'dc_hostgroup_mysql': }

}
