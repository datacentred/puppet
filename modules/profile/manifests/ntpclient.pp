class profile::ntpclient {

	$localtimeservers = hiera_array('localtimeservers')
	
	class { "ntp":
		servers    => $timeservers,
		autoupdate => false,
    	}
}
