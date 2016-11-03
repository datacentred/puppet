# == Class: ::dc_docker::rocker
#
# Install Rocker which extends the Dockerfile build
# syntax and process
#
class dc_docker::rocker (
  $version = '1.3.0',
  $baseurl = 'https://github.com/grammarly/rocker/releases/download/',
  $packagename = 'rocker_linux_amd64.tar.gz',
) {

  wget::fetch { $packagename:
    source      => "${baseurl}/${version}/${packagename}",
    destination => "/var/tmp/${packagename}",
  }->
  exec { "install ${packagename}":
    command => "tar xf /var/tmp/${packagename} -C /usr/local/bin/",
    creates => '/usr/local/bin/rocker',
  }

}
