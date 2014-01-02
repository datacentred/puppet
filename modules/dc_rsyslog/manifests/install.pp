# Install rsyslog from local mirror
class dc_rsyslog::install {
  # Initialise the rsyslog mirror
  package { 'rsyslog':
    ensure  => latest,
    require => Dc_repos::Virtual::Repo['local_rsyslog_mirror']
  }
  # We need to do this to ensure that the repo is properly refreshed and to ensure we get the latest rsyslog package
  exec { 'apt-get-update-private-repo':
    command => "apt-get update -o Dir::Etc::sourcelist='sources.list.d/local_rsyslog_mirror.list' -o Dir::Etc::sourceparts='-' -o APT::Get::List-Cleanup='0'",
    onlyif  => "wget -q -N -P /tmp http://mirror.sal01.datacentred.co.uk/mirror/ubuntu.adiscon.com/v8-devel/precise/Packages && ! cmp -s /tmp/Packages mirror.sal01.datacentred.co.uk:80_mirror_ubuntu.adiscon.com_v8-devel_precise_Packages",
    path    => [ '/usr/bin', '/bin' ],
  }
}
