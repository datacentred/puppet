class profile::gitmaster {

	package { 'git' 
		ensure => installed,
	}

# FIXME need to ensure our post commit hooks are also in place on the master
# This will currently be a hook to deploy if change is in dev branch and a hook to push upstream to github
# This will also need keys installing to do git push to github

}
