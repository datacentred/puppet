apt::source { 'ubuntu cloud archive':
	location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
	release           => 'precise-updates/grizzly',
	repos             => 'main',
}

