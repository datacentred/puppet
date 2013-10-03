class profile::sudoers {

	class { sudo: }

	sudo::conf { '%sysadmin':
		priority => 10,
		content	 => '%sysadmin ALL=(ALL) NOPASSWD: ALL',
	}

}
