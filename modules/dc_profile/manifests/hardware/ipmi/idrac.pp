# Class: dc_profile::hardware::ipmi::idrac
#
# Configure LDAP authentication and hostname on DELL iDRAC
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_profile::hardware::ipmi::idrac {

  $ldap_server     = hiera(ipmi::authentication::server)
  $ldap_base_dn    = hiera(ldap_suffix)
  $ldap_role_group = hiera(ipmi::authentication::ldap_role_group)

  # Install racadm and start dataeng service
  include dc_profile::dell::openmanage
  # Create a symlink to racadm in /usr/bin/racadm
  # because drac_setting expects it to be set
  file {'/usr/bin/racadm':
    ensure => 'link',
    target => '/opt/dell/srvadmin/sbin/racadm',
    require => Class['dc_profile::dell::openmanage'],
  }

  # set the hostname
  drac_setting { 'cfgLanNetworking/cfgDNSRacName':
    object_value => "${::hostname}-drac",
    require => Service['dataeng'],
  }

  # configure ldap authentication
  drac_setting { 'cfgldap/cfgLdapEnable':
    object_value => 1,
    require => Service['dataeng'],
  }

  # this should be in hiera
  drac_setting { 'cfgldap/cfgLdapServer':
    object_value => $ldap_server,
    require => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapPort':
    object_value => 636,
    require => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapBaseDN':
    object_value => $ldap_base_dn,
    require => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapCertValidationenable':
    object_value => 0,
    require => Service['dataeng'],
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupDN':
    object_value => $ldap_role_group,
    require => Service['dataeng'],
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupPrivilege':
    object_value => 0x01ff,
    require => Service['dataeng'],
  }
}