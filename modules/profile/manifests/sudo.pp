class profile::sudo {

	sudo::conf { 'sysadmin':
		priority => 10,
		content	 => '%sysadmin ALL=(ALL) NOPASSWD: ALL',
	}

}
