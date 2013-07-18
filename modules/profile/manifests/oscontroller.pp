class profile::oscontroller {

	package { 'python-mysqldb'
		ensure => installed,
	}

}
