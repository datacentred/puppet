# Class: dc_dns::cname
#
# Creates a CNAME record
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define dc_dns::cname(
  $ensure   = 'present',
  $alias_to = undef,
  $ttl      = '86400',
) {

  @@dns_resource { "${title}/CNAME":
    ensure => $ensure,
    rdata  => $alias_to,
    ttl    => $ttl,
  }

}