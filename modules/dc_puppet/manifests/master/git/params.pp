#
class dc_puppet::master::git::params {
  $home   = '/home/git'
  $repo   = "${home}/puppet.git"
  $remote = 'git@github.com:datacentred/puppet.git'
}
