# == Class: dc_icinga2::services::iptables_rule
#
# Checks if an iptables rule is present on a set of routers.
#
class dc_icinga2::services::iptables_rule (
  $username,
  $password,
  $auth_url,
  $proj_domain,
  $usr_domain,
  $proj_name,
  $rule,
  $ids,
) {
  icinga2::object::apply_service { 'iptables rule':
    import        => 'openstack-service',
    check_command => 'iptables_rule',
    vars          => {
      'enable_pagerduty'          => true,
      'iptables_rule_username'    => $username,
      'iptables_rule_password'    => $password,
      'iptables_rule_auth_url'    => $auth_url,
      'iptables_rule_proj_domain' => $proj_domain,
      'iptables_rule_usr_domain'  => $usr_domain,
      'iptables_rule_proj_name'   => $proj_name,
      'iptables_rule_rule'        => $rule,
      'iptables_rule_ids'         => $ids,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
