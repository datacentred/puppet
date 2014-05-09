# Use this file to define the puppet modules you want to test

contain dc_role::generic
contain dc_profile::auth::ldap::server

class { 'ldap::client':
  uri  => 'ldap://127.0.0.1',
  base => 'dc=example,dc=com',
} ->

ldap_entry { 'cn=Foo,ou=Bar,dc=example,dc=com':
  ensure      => present,
  host        => '1.2.3.4',
  port        => 389,
  username    => 'admin',
  password    => 'password',
  attributes  => { givenName   => 'Foo',
                  objectClass  => ['top', 'person', 'inetorgPerson']}
}