# All nodes get this class as it allows control over the puppet
# configuration file, which is important for foreman and its
# proxies as they need access to the the host's private key
class dc_profile::puppet {

  # Puppet master will provide this so avoid duplication
  if !defined(Class['::dc_role::platformservices_puppetmaster']) or
     !defined(CLass['::dc_profile::puppetmaster']) {
    class { '::puppet': }
  }

}
