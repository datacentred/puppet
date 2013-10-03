# This uses the custom types from the augueasproviders module
# so that needs to be installed on the puppetmaster for this to work.

class profile::sshconfig {

	sshd_config { "AllowGroups":
		ensure => present,
		value => "sysadmin",
	}

}
