class profile::rabbitmq {
	
	package { 'rabbitmq-server'
		ensure => installed
	}

}
