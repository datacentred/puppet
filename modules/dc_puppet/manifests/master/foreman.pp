#
class dc_puppet::master::foreman {

  class { 'dc_foreman_proxy':
    use_puppetca => true,
    use_puppet   => true,
  }
  contain 'dc_foreman_proxy'
  contain dc_puppet::master::foreman::config

}

