class dc_ldap {
  file { '/etc/ldap/schema/hpilo.schema':
    source => 'puppet:///modules/dc_ldap/hpilo.schema',
  }
}
