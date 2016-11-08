# == Class: dc_resolvconf
#
# This class is used to insert some custom options into resolv.conf
#
# == Parameters
#
# [*dnsclient_tail*]
#   String. Tail for resolv.conf
#
class dc_resolvconf (
  $dnsclient_tail = "options timeout:1 attempts:2 rotate\n",
) {
    file { '/etc/resolvconf/resolv.conf.d/tail':
      content => $dnsclient_tail,
    } ~>
    exec { 'resolvconf -u':
      refreshonly => true,
    }
}
