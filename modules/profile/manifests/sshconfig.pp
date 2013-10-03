class profile::sshconfig {

	sshd_config { "AllowGroups":
		ensure => present,
		value => "sysadmin",
	}

}
