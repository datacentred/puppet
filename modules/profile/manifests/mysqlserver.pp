class profile::mysqlserver {
	
	class { 'mysql::server':
		config_hash => { 'root_password' => 'foo' }
	}

} 
