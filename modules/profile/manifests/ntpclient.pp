class profile::ntpclient {

	$timeserver = hiera('timeserver')
	
	class { "ntp":
		servers    => [ $timeserver ],
		autoupdate => false,
    	}
}
