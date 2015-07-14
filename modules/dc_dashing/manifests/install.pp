# == Class: dc_dashing::install
#
#install dashing to dir
#
# === Examples
# class { 'dc_dashing::install' }
class dc_dashing::install {

  ensure_packages(['ruby1.9.1-dev', 'build-essential', 'nodejs'])

  package { 'dashing':
    ensure   => present,
    provider => 'gem',
  }

  exec { 'Install Dashing Instance':
    command => '/usr/local/bin/dashing new dashing',
    cwd     => '/opt/',
    creates => '/opt/dashing/widgets/text/text.scss',
    require => Package['dashing'],
    user    => root,
    group   => root,
  }->
  file{ '/opt/dashing/Gemfile':
    ensure  => file,
    content => template('dc_dashing/Gemfile.erb'),
  }
}
