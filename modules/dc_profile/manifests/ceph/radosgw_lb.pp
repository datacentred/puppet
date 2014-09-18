# == Class: dc_profile::ceph::radosgw_lb
#
# Provide a load balancer across the set of gateways
#
class dc_profile::ceph::radosgw_lb (
  $keepalived_interface,
  $keepalived_virtual_router_id,
  $keepalived_virtual_ipaddress,
) {

  include ::haproxy
  include ::keepalived
  include ::dc_ssl::haproxy

  # TODO: match() function in 3.7+
  $keepalived_instance_id = inline_template('<%= /\d+$/.match(@hostname) %>')
  $keepalived_priority = 100 - $keepalived_instance_id

  keepalived::vrrp::instance { "VI_${keepalived_virtual_router_id}":
    interface          => $keepalived_interface,
    state              => 'SLAVE',
    priority           => $keepalived_priority,
    virtual_router_id  => $keepalived_virtual_router_id,
    virtual_ipaddress  => $keepalived_virtual_ipaddress,
  }

  haproxy::listen { 'radosgw':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '443',
    bind_options => [
      'ssl',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk GET / HTTP/1.1', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

}
