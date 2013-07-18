class profile::ntpclient {

	$timeservers = hiera_array('timeserver')
	
	class { "ntp":
		servers    => $timeservers,
		autoupdate => false,
    	}
}
