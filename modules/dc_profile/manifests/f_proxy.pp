class dc_profile::f_proxy {

  class { 'foreman_proxy':
    repo                => 'stable',
    ssl                 => 'false',
    trusted_hosts       => [],
    manage_sudoersd     => 'false',
    puppetca            => 'false',
    puppetrun           => 'false',
    tftp                => 'false',
    dhcp                => 'false',
    dns                 => 'true',
    keyfile             => '/etc/bind/rndc.key',
    register_in_foreman => 'false',
  }

}
