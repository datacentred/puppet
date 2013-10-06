class repos::repolist {

include repos::virtual

	$mirrorserver = hiera(mirror_server)
	$ubuntumirrorpath = hiera(ubuntu_mirror_path)
	$ubuntusecmirrorpath = hiera(ubuntu_security_mirror_path)
	$puppetmirrorpath = hiera(puppet_mirror_path)
	$cephcmirrorpath = hiera(ceph_c_mirror_path)
	$cephdmirrorpath = hiera(ceph_d_mirror_path)
	$nullmailermirrorpath = hiera(nullmailer_mirror_path)



	@repos::virtual::repo { 'local_precise_mirror':
		location          => "$mirrorserver/$ubuntumirrorpath",
		release           => 'precise',
		repos             => 'main restricted universe multiverse',
		tag		  => baserepos
	}
	
	@repos::virtual::repo { 'local_precise_updates_mirror':
		location          => "$mirrorserver/$ubuntumirrorpath",
		release           => 'precise-updates',
		repos             => 'main restricted universe multiverse',
		tag		  => baserepos
	}

	@repos::virtual::repo { 'local_precise_security_mirror':
		location          => "$mirrorserver/$ubuntusecmirrorpath",
		release           => 'precise-security',
		repos             => 'main restricted universe',
		tag		  => baserepos
	}

	@repos::virtual::repo { 'local_puppetlabs_mirror':
		location	  => "$mirrorserver/$puppetmirrorpath",
		release		  => 'precise',
		repos		  => 'main dependencies',
		tag		  => baserepos
	}

	@repos::virtual::repo { 'local_nullmailer_backports_mirror':
		location	  => "$mirrorserver/$nullmailermirrorpath",
		release		  => 'precise',
		repos		  => 'main',
		key		  => 'E8B30951'
		key_server	  => 'keyserver.ubuntu.com'
		tag		  => baserepos
	}

        @repos::virtual::repo { 'ceph_c_mirror':
                location          => "$mirrorserver/$cephcmirrorpath",
                release           => 'precise',
                repos             => 'main',
		key		  => '17ED316D',
		key_server	  => 'keyserver.ubuntu.com'
        }
        
	@repos::virtual::repo { 'ceph_d_mirror':
                location          => "$mirrorserver/$cephdmirrorpath",
                release           => 'precise',
                repos             => 'main',
		key		  => '17ED316D',
		key_server	  => 'keyserver.ubuntu.com'
	}

}	
