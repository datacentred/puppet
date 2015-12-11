# == dc_haproxy::service
#
define dc_haproxy::service (
) {

  file { "/etc/init.d/haproxy-${title}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('dc_haproxy/haproxy-service.erb'),
  }

}
