class profile::sudo {

	class { 'sudo': }
	sudo::conf { '%sysadmin':
		priority => 10,
		content	 => '%sysadmin ALL=(ALL) NOPASSWD: ALL',
	}

}
