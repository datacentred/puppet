class dc_postfix::networks {

  $client_networks = join(hiera(client_networks), ', ')

  postfix::config { 'mydestination':
    value => "localhost.localdomain, localhost, ${::fqdn}",
  }
  postfix::config { 'mynetworks':
    value => "127.0.0.0/8, ${client_networks}",
  }
  postfix::config {'inet_protocols':
    value => 'ipv4',
  }

}
