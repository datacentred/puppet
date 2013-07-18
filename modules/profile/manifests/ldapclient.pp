class profile::ldapclient {

	$ldapbasedn = hiera(ldap_base_dn)
	$ldapuri = hiera(ldap_uri)

	class { 'ldap':
		base => $ldapbasedn,
		uri  => $ldapuri,
	}

}
	
	
