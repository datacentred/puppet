# Class: dc_profile::openstack::keystone_ldap
#
# Provision the OpenStack Keystone component
#
# With LDAP as the backend
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::keystone_ldap {

  $suffix         = hiera(shared_ldap_suffix)
  $user_tree_dn   = "ou=Users,dc=openstack,${suffix}"
  $group_tree_dn  = "ou=Groups,dc=openstack,${suffix}"
  $tenant_tree_dn = "ou=Projects,dc=openstack,${suffix}"
  $role_tree_dn   = "ou=Roles,dc=openstack,${suffix}"

  class { 'keystone::ldap':
    url                         => hiera(shared_ldap_host),
    user                        => hiera(shared_ldap_rootdn),
    password                    => hiera(shared_ldap_rootpw),
    suffix                      => suffix,
    query_scope                 => 'sub',
    user_tree_dn                => $user_tree_dn,
    user_id_attribute           => 'cn',
    user_name_attribute         => 'sn',
    user_mail_attribute         => 'mail',
    user_allow_create           => 'True',
    user_allow_update           => 'True',
    user_allow_delete           => 'True',
    user_objectclass            => 'inetOrgPerson',
    group_tree_dn               => $group_tree_dn,
    group_objectclass           => 'groupOfNames',
    group_id_attribute          => 'cn',
    group_name_attribute        => 'ou',
    group_member_attribute      => 'roleOccupant',
    group_desc_attribute        => 'description',
    group_allow_create          => 'True',
    group_allow_update          => 'True',
    group_allow_delete          => 'True',
    tenant_tree_dn              => $tenant_tree_dn,
    tenant_objectclass          => 'groupOfNames',
    tenant_id_attribute         => 'cn',
    tenant_member_attribute     => 'member',
    tenant_name_attribute       => 'ou',
    tenant_desc_attribute       => 'description',
    tenant_allow_create         => 'True',
    tenant_allow_update         => 'True',
    tenant_allow_delete         => 'True',
    role_tree_dn                => $role_tree_dn,
    role_objectclass            => 'organizationalRole',
    role_id_attribute           => 'cn',
    role_name_attribute         => 'ou',
    role_member_attribute       => 'roleOccupant',
    role_allow_create           => 'True',
    role_allow_update           => 'True',
    role_allow_delete           => 'True',
    identity_driver             => 'keystone.identity.backends.ldap.Identity',
    assignment_driver           => 'keystone.assignment.backends.ldap.Assignment',
    use_tls                     => 'True',
    tls_cacertfile              => '/etc/ssl/certs/ca-certificates.crt',
    tls_req_cert                => 'allow',
  }

}
