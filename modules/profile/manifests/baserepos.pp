class profile::baserepos {

	include profile::dpkg
	include repos::repolist

	class { 'apt': 
		purge_sources_list   => true,
		purge_sources_list_d => true,
	}

	Repos::Virtual::Repo <| tag == baserepos |>

}

