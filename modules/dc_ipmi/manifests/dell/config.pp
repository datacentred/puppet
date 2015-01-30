# Class: dc_ipmi::dell::config
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
class dc_ipmi::dell::config {

  # set the hostname
  drac_setting { 'cfgLanNetworking/cfgDNSRacName':
    object_value => "${::hostname}-drac",
    require      => Service['dataeng'],
  }

  # configure ldap authentication
  drac_setting { 'cfgldap/cfgLdapEnable':
    object_value => 1,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapServer':
    object_value => $dc_ipmi::ldap_server,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapPort':
    object_value => $dc_ipmi::ldap_port,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapBaseDN':
    object_value => $dc_ipmi::ldap_basedn,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldap/cfgLdapCertValidationenable':
    object_value => 0,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupDN':
    object_value => $dc_ipmi::ldap_role_group,
    require      => Service['dataeng'],
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupPrivilege':
    object_value => 0x01ff,
    require      => Service['dataeng'],
  }
}
