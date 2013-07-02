class profile::ntpconfig {
	
	class { "ntp":
		servers    => [ '10.1.5.10' ],
		autoupdate => false,
    	}
}
