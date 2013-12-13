# Installs GPG enabled yaml configuration on a puppet master
# obviously you will need to manualy install the private keys
# as we don't want them in cloud!  And do it *before* installing
# this class
class dc_hiera_yamlgpg (
  $key_dir = '/etc/puppet/keys',
) {

  package { 'ruby-gpgme':
    ensure => 'present',
  }

  # Create the configuration
  file { '/etc/puppet/hiera.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_hiera_yamlgpg/hiera.yaml.erb'),
  }

  # And importantly make sure the keys directory has
  # write permissions for puppet.  Force a service
  # restart to pick up the new configuration
  file { $key_dir:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0750',
    notify => Service['apache2'],
  }

}
