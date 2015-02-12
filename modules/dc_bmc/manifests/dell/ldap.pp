# Class: dc_bmc::dell::ldap
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
class dc_bmc::dell::ldap {

  # configure ldap authentication
  drac_setting { 'cfgldap/cfgLdapEnable':
    object_value => 1,
  }

  drac_setting { 'cfgldap/cfgLdapServer':
    object_value => $dc_bmc::ldap_server,
  }

  drac_setting { 'cfgldap/cfgLdapPort':
    object_value => $dc_bmc::ldap_port,
  }

  drac_setting { 'cfgldap/cfgLdapBaseDN':
    object_value => $dc_bmc::ldap_basedn,
  }

  drac_setting { 'cfgldap/cfgLdapCertValidationenable':
    object_value => 0,
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupDN':
    object_value => $dc_bmc::ldap_role_group,
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupPrivilege':
    object_value => '0x000001ff',
  }

}
