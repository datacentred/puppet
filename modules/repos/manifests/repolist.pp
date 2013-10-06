class repos::repolist {

include repos::virtual

	$mirrorserver = hiera(mirror_server)
	$ubuntumirrorpath = hiera(ubuntu_mirror_path)
	$ubuntusecmirrorpath = hiera(ubuntu_security_mirror_path)
	$puppetmirrorpath = hiera(puppet_mirror_path)
	$nullmailermirrorpath = hiera(nullmailer_mirror_path)



	@repos::virtual::repo { 'local_precise_mirror':
		location          => "$mirrorserver/$ubuntumirrorpath",
		release           => 'precise',
		repos             => 'main restricted universe multiverse',

	}
	
	@repos::virtual::repo { 'local_precise_updates_mirror':
		location          => "$mirrorserver/$ubuntumirrorpath",
		release           => 'precise-updates',
		repos             => 'main restricted universe multiverse',

	}

	@repos::virtual::repo { 'local_precise_security_mirror':
		location          => "$mirrorserver/$ubuntusecmirrorpath",
		release           => 'precise-security',
		repos             => 'main restricted universe',
	}

	@repos::virtual::repo { 'local_puppetlabs_mirror':
		location	=> "$mirrorserver/$puppetmirrorpath",
		release		=> 'precise',
		repos		=> 'main dependencies',
	}

	@repos::virtual::repo { 'local_nullmailer_backports_mirror':
		location	=> "$mirrorserver/$nullmailermirrorpath",
		release		=> 'precise',
		repos		=> 'main',
	}

        @repos::virtual::repo { 'ceph':
                location          => "http://ceph.com/debian-cuttlefish/",
                release           => 'precise',
                repos             => 'main',

        }

}	
