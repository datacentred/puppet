# Class: dc_profile::log::kibana
#
# Installs the logstash GUI
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::kibana {
  include ::apache

  class { 'kibana4':
    plugins => {
      'elastic/sense'                    => {
        'ensure'          => 'present',
        'plugin_dest_dir' => 'sense',
      },
      'elastic/timelion'                 => {
        'ensure'          => 'present',
        'plugin_dest_dir' => 'timelion',
      },
      'elasticsearch/marvel'             => {
        'ensure'          => 'present',
        'plugin_dest_dir' => 'marvel',
      },
      'oxalide/kibana_metric_vis_colors' => {
        'plugin_dest_dir' => 'marvel',
        'ensure'          => 'present',
        'url'             => 'https://github.com/Oxalide/kibana_metric_vis_colors/archive/master.zip'
      },
      'stormpython/vectormap'            => {
        'plugin_dest_dir' => 'vectormap',
        'ensure'          => 'present',
        'url'             => 'https://github.com/stormpython/vectormap/archive/master.zip'
      }
    }
  }


  #Apache vhost config, proxies http requests to kibana server instance
  apache::vhost{ 'kibana':
    servername => "kibana.${::domain}",
    docroot    => '/opt/kibana4',
    port       => '80',
    priority   => '000',
    proxy_pass => [
      {
        'path'         => '/' ,
        'url'          => 'http://127.0.0.1:5601',
        'reverse_urls' =>  ['/', 'http://127.0.0.1:5601' ]
      },
    ],
    rewrites   => [
      {
        comment      => 'Kibana rewrite',
        rewrite_cond => ['%{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f'],
        rewrite_rule => ['.* http://127.0.0.1:5601%{REQUEST_URI} [P,QSA]']
      }
    ]
  }
}
