class profile::ntpclient {

	$timeservers = hiera_array('timeservers')
	
	class { "ntp":
		servers    => $timeservers,
		autoupdate => false,
    	}
}
