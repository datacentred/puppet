# == Class: llama::repo
#
# Controls the llama source
#
class llama::repo {

  # Installs the repo from a customized source e.g. github
  ensure_packages('git')

  Package['git'] ->

  vcsrepo { '/opt/llama':
    ensure   => present,
    provider => 'git',
    source   => $::llama::llama_repo_source,
  }

}
