# == Class: dc_nrpe::checks::foreman_interfaces
#
class dc_nrpe::checks::foreman_interfaces (
  $ignored_interfaces = [],
){

  $config = {
    'managed_interfaces' => foreman_managed_interfaces(),
    'ignored_interfaces' => $ignored_interfaces,
  }

  file { '/usr/local/etc/check_foreman_interfaces.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => inline_template('<%= YAML.dump(@config) %>'),
  }

  dc_nrpe::check { 'check_foreman_interfaces':
    path   => '/usr/local/bin/check_foreman_interfaces.py',
    source => 'puppet:///modules/dc_nrpe/check_foreman_interfaces.py',
    sudo   => true,
  }

}
