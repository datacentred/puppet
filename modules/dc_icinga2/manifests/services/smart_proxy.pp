# == Class: dc_icinga2::services::smart_proxy
#
# Monitoring for Foreman smart proxies
#
class dc_icinga2::services::smart_proxy (
  $host,
  $username,
  $password,
  $omapi_username,
  $omapi_key,
) {

  icinga2::object::apply_service { 'smart_proxy':
    import        => 'daily-service',
    check_command => 'smart_proxy',
    vars          => {
      'smart_proxy_host'           => $host,
      'smart_proxy_username'       => $username,
      'smart_proxy_password'       => $password,
      'smart_proxy_omapi_username' => $omapi_username,
      'smart_proxy_omapi_key'      => $omapi_key,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "dns_master"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
