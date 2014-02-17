#
class dc_profile::foreman_puppet_proxy {

  class { 'dc_foreman_proxy' :
    use_puppetca => true,
    use_puppet   => true,
  }

}
