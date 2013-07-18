class profile::mysqlserver {
	
	package { 'mysql-server':
		ensure => installed,
	}

	class { 'mysql::server':
		config_hash => { 'root_password' => 'foo' }
	}

} 
