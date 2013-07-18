class profile::os-controller {
	
	include profile::mysql

	package { 'rabbitmq-server'
		ensure => installed
	}

	package { 'python-mysqldb'
		ensure => installed
	}

}
