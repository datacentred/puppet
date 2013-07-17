class profile::cloudarchive {

	class { 'apt': }

	apt::source { 'ubuntu_cloud_archive':
		location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
		release           => 'precise-updates/grizzly',
		repos             => 'main',
		key        => 'EC4926EA',
      		key_server => 'keyserver.ubuntu.com',

	}

}

