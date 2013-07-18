class profile::ntpclient {
# FIXME Use hiera to define the IP	
	class { "ntp":
		servers    => [ '10.1.5.10' ],
		autoupdate => false,
    	}
}
