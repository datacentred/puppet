class profile::ceph {

	user { "cephadmin":
		comment => 'Ceph user created by Puppet',
		ensure => 'present',
		managehome => 'true',
	}

	file { "/home/cephadmin/.ssh":
		ensure => 'directory',
		require => User['cephadmin'],
		owner => 'cephadmin',
		mode => '0700',
	}

	file { "/etc/sudoers.d/ceph":
		mode => 440,
		owner => cephadmin,
		source => "puppet:///modules/profile/sudoers.ceph"
	}

}
