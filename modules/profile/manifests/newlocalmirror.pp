class profile::newlocalmirror {

	include profile::dpkg
	include repos::repolist

	class { 'apt': 
		purge_sources_list => true,
		purge_sources_list_d => true,
	}

	realize (Repos::Virtual::Repo['local_precise_mirror'])

}

