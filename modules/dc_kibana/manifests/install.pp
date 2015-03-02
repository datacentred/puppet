# == Class: dc_kibana::install
#
class dc_kibana::install {

  file { '/var/www':
        ensure  => directory,
        recurse => true,
  }

  exec { 'install_kibana':
    command => 'wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz \
                && sudo tar xzf kibana-4.0.0-linux-x64.tar.gz -C /var/www/ \
                && sudo mv kibana-4.0.0-linux-x64 kibana',
    cwd     => '/var/www',
    path    => ['/bin', '/usr/bin'],
    creates => '/var/www/kibana-4.0.0-linux-x64.tar.gz',
    require => File['/var/www'],
  }

}
