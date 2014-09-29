# == Class: dc_ldap
#
class dc_ldap {
  file { '/etc/ldap/schema/hpilo.schema':
    source => 'puppet:///modules/dc_ldap/hpilo.schema',
  }
  file { '/etc/ldap/schema/freeradius.schema':
    source => 'puppet:///modules/dc_ldap/freeradius.schema',
  }
}
