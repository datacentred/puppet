# FIXME fix version to use ssl
class profile::mail {

	$smarthostuser = hiera('smarthostuser')
	$smarthostpass = hiera('smarthostpass')
	$smarthost    = hiera('smarthost')
	$sysmailaddress = hiera('sysmailaddress')

	class {'nullmailer':
    		adminaddr => "$sysmailaddress",
		remoterelay => "$smarthost",
		remoteopts => "--auth-login --ssl --port=465 --user=$smarthostuser --pass=$smarthostpass",
	}
}
