class profile::mysql-server {
	
	package { 'mysql'
		ensure => installed
	}

} 
