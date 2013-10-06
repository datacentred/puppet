class profile::baserepos {

	include profile::dpkg
	include repos::repolist

	class { 'apt': 
		purge_sources_list => true,
		purge_sources_list_d => true,
	}

	realize (Repos::Virtual::Repo['local_precise_mirror'])
	realize (Repos::Virtual::Repo['local_precise_updates_mirror'])
	realize (Repos::Virtual::Repo['local_precise_security_mirror'])
	realize (Repos::Virtual::Repo['local_puppetlabs_mirror'])
	realize (Repos::Virtual::Repo['local_nullmailer_backports_mirror'])

}

