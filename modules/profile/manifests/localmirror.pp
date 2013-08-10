class profile::localmirror {

	include profile::dpkg

	$mirrorserver = hiera(ubuntu_mirror_server)
	$mirrorpath = hiera(ubuntu_mirror_path)
	$puppetmirrorpath = hiera(puppet_mirror_path)

	class { 'apt': 
		purge_sources_list => true,
		purge_sources_list_d => true,
	}


	apt::source { 'local_precise_mirror':
		location          => "$mirrorserver/$mirrorpath",
		release           => 'precise',
		repos             => 'main restricted universe',
		include_src	  => false,

	}
	
	apt::source { 'local_precise_updates_mirror':
		location          => "$mirrorserver/$mirrorpath",
		release           => 'precise-updates',
		repos             => 'main restricted universe',
		include_src	  => false,

	}

	apt::source { 'local_puppetlabs_mirror':
		location	=> "$mirrorserver/$puppetmirrorpath",
		release		=> 'precise',
		repos		=> 'main dependencies',
		include_src	=> false,
	}



}

