class profile::users {
	
	group { "devops":
		ensure => present;
		gid => 1000;
	}

	user { "mattj":
		ensure => present;
		managehome => true;
		shell => '/bin/bash';
		gid => devops;
		uid => 1000;
	}

}

