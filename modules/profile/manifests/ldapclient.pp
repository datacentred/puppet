class profile::ldapclient {

	class { 'ldap':
		# FIXME Use hiera for both of these
		base => 'dc=sal01,dc=datacentred,dc=co,dc=uk',
		uri  => 'ldap://10.1.5.10',
	}

}
	
	
