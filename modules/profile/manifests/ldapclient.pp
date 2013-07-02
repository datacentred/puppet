class profile::ldapclient {

	class { 'ldap':
		base => 'dc=sal01,dc=datacentred,dc=co,dc=uk',
		uri  => 'ldap://10.1.5.10',
	}

}
	
	
