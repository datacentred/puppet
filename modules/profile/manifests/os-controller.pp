class profile::os-controller {

	package { 'python-mysqldb'
		ensure => installed
	}

}
