class ceph {

	user { "cephadmin":
		commend => 'This user was created by Puppet',
		ensure => 'present',
		managed_home => 'true',
	}

	file { "/home/cephadmin/.ssh":
		ensure => 'directory',
		require => User['cephadmin'],
		owner => 'cephadmin',
		mode => '0700',
	}

}
