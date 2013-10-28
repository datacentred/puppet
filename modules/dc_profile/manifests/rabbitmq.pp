class dc_profile::rabbitmq {

  package { 'rabbitmq-server':
    ensure => installed
  }

}
