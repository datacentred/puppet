class profile::ntpclient {

	$localtimeservers = hiera_array('localtimeservers')
	
	class { "ntp":
		servers    => $localtimeservers,
		autoupdate => false,
    	}
}
