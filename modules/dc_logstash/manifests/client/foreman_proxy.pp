# Class: dc_logstash::client::foreman_proxy
#
# Logstash config for foreman proxy logs
#
class dc_logstash::client::foreman_proxy {

  dc_logstash::client::register { 'foreman_proxy':
    logs   => '/var/log/foreman-proxy/foreman-proxy.log',
    fields => {
      'type' => 'foreman_proxy',
    }
  }

}
