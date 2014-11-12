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

  # Install racadm
  include dc_ipmi::dell::racadm

  # Create a symlink to racadm in /usr/bin/racadm
  # because drac_setting expects it to be set
  file {'/usr/bin/racadm':
    ensure => 'link',
    target => '/opt/dell/srvadmin/sbin/racadm',
    require => Class['dc_ipmi::dell::racadm'],
  }

  # set the hostname
  drac_setting { 'cfgLanNetworking/cfgDNSRacName':
    object_value => "${::hostname}-drac",
    require => File['/usr/bin/racadm'],
  }

  # configure ldap authentication
  drac_setting { 'cfgldap/cfgLdapEnable':
    object_value => 1
  }

  # this should be in hiera
  drac_setting { 'cfgldap/cfgLdapServer':
    object_value => '10.10.192.111' 
  }

  drac_setting { 'cfgldap/cfgLdapPort':
    object_value => 636
  }

  drac_setting { 'cfgldap/cfgLdapBaseDN':
    object_value => 'dc=datacentred,dc=co,dc=uk'
  }

  drac_setting { 'cfgldap/cfgLdapCertValidationenable':
    object_value => 0
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupDN':
    object_value => 'cn=iLO Admins,ou=Groups,dc=datacentred,dc=co,dc=uk'
  }

  drac_setting { 'cfgldaprolegroup/1/cfgLdapRoleGroupPrivilege':
    object_value => 0x01ff
  }
}