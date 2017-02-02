# == Class: llama::install
#
# Installs requisite packages
#
class llama::install {

  assert_private()

  ensure_packages('python-setuptools')

  file {'/usr/local/bin/llama_telegraf.py':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/llama/llama_telegraf.py',
  }

}
