class profile::cephrepo {

	class { 'apt': 
		purge_sources_list => false,
		purge_sources_list_d => false,
	}


	apt::source { 'ceph':
		location          => "http://ceph.com/debian-cuttlefish/",
		release           => 'precise',
		repos             => 'main',
		include_src	  => false,

	}

}

