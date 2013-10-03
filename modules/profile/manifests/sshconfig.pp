# This uses the custom types from the augueasproviders module
# so that needs to be installed on the puppetmaster for this to work.

class profile::sshconfig {

	service { sshd: 
		ensure => true,
		enable => true,
		hasrestart => true
	}

	sshd_config { "AllowGroups":
		ensure => present,
		value => "sysadmin",
	}

	sshd_config { "AllowRootLogin":
		ensure => present,
		value => "no",
	}

	notify => Service["sshd"]

}
