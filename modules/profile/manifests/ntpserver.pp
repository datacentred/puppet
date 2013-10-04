class profile::ntpserver {

	$upstreamtimeservers = hiera_array('upstreamtimeservers')
	
	class { "ntp":
		servers    => $upstreamtimeservers,
		autoupdate => false,
		restrict   => false,
    	}
}
