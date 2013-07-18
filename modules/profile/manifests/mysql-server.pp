class profile::mysql-server {
	
	package { 'mysql-server'
		ensure => installed
	}

	class { 'mysql::server':
		config_hash => { 'root_password' => 'foo' }
	}

} 
