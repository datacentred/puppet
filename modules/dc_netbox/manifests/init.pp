# == Class: dc_netbox
#
class dc_netbox (
  $password,
  $db_password,
  $secretkey,
  $yaml = '/root/netbox/docker-compose.yml',
  $yaml80 = '/root/netbox/nginx-port80.yml',
  $dir = '/root/netbox',
  $docker = '/root/netbox/Dockerfile',
  $git = 'https://github.com/digitalocean/netbox-docker.git',
  $docker_compose = 'dc_netbox/docker-compose.yml.erb',
  $dockerfile = 'dc_netbox/Dockerfile.erb',
  $nginx_port80 = 'dc_netbox/nginx-port80.yml.erb',
  $mail = 'devops@datacentred.co.uk',
  ) {
  include ::docker::compose
  include ::firewall
  include ::dc_netbox::security

  vcsrepo { $dir:
    ensure   => present,
    provider => git,
    source   => $git,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { $yaml:
    content => template($docker_compose),
    require => Vcsrepo[$dir]
  }

  file { $docker:
    content => template($dockerfile),
    require => File[$yaml]
  }

  file { $yaml80:
    content => template($nginx_port80),
    require => File[$docker]
  }

  docker_compose { $yaml:
    ensure  => present,
    require => File[$yaml80]
  }

  docker_compose { $yaml80:
    ensure  => present,
    require => Docker_compose[$yaml]
  }
}
