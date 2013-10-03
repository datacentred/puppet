class profile::mail {

	smarthostuser = hiera('smarthostuser')
	smarthostpass = hiera('smarthostpass')
	smarthost    = hiera('smarthost')
	sysmailaddress = hiera('sysmailaddress')

	class {'nullmailer':
    		adminaddr => "$sysmailaddress",
		remoterelay => "$smarthost",
		remoteopts => "--user=$smarthostuser --pass=$smarthostpass",
	}
}
