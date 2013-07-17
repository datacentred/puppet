class profile::localrepo {

	class { 'apt': 
		purge_sources_list => true,
		purge_sources_list_d => true,
	}


	apt::source { 'local_precise_mirror':
		location          => 'http://mirror.sal01.datacentred.co.uk:80/mirror/gb.archive.ubuntu.com/ubuntu',
		release           => 'precise',
		repos             => 'main restricted',

	}
	
	apt::source { 'local_precise_updates_mirror':
		location          => 'http://mirror.sal01.datacentred.co.uk:80/mirror/gb.archive.ubuntu.com/ubuntu',
		release           => 'precise-updates',
		repos             => 'main restricted',

	}

}


}

