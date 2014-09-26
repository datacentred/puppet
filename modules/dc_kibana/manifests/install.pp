# == Class: dc_kibana::install
#
class dc_kibana::install {

  file { '/var/www':
        ensure  => directory,
        recurse => true,
  }

  exec { 'install_kibana':
    command => 'wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz \
                && tar xzf kibana-latest.tar.gz -C /var/www/ \
                && mv kibana-latest kibana',
    cwd     => '/var/www',
    path    => ['/bin', '/usr/bin'],
    creates => '/var/www/kibana-latest.tar.gz',
    require => File['/var/www'],
  }

}
