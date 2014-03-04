# Class: dc_dns::host
#
# Creates A and PTR records
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_dns::host (
  $ensure = 'present',
  $ipv4   = undef,
  $ttl    = '86400',
) {

  $o = split($ipv4, '[.]')
  $reverse = "${o[3]}.${o[2]}.${o[1]}.${o[0]}.in-addr.arpa"

  @@dns_resource { "${title}.${::domain}/A":
    ensure => $ensure,
    rdata  => $ipv4,
    ttl    => $ttl,
  }

  @@dns_resource { "${reverse}/PTR":
    ensure => $ensure,
    rdata  => "${title}.${::domain}",
    ttl    => $ttl,
  }

}
