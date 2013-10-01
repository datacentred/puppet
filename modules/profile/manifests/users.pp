class profile::users {
	
	$shell = '/bin/blah'

	group { "devops":
		ensure => present,
		gid => 1000,
	}

	user { "mattj":
		ensure => present,
		managehome => true,
		groups => devops,
		uid => 1000,
	}

	user { "nick":
		ensure => present,
		managehome => true,
		shell => '/bin/bash',
		groups => devops,
		uid => 1001,
	}

	user { "dariush":
		ensure => present,
		managehome => true,
		shell => '/bin/bash',
		groups => devops,
		uid => 1002
	}
}

