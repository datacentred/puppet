# Type: dc_rails::service
#
# Configure a Rails bin as a service
#
define dc_rails::service(
  $type              = undef,
  $description       = undef,
  $environment_file  = undef,
  $working_directory = undef,
  $command           = undef,
  $pid_file          = undef,
  $unicorn           = undef
) {

  file { "/lib/systemd/system/${name}.service":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_rails/service.erb'),
  } ~>

  exec { "systemctl-daemon-reload-${name}":
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  } ~>

  if $unicorn {
    service { $name:
      ensure  => 'running',
      restart => "systemctl reload ${name}",
    }
  } else {
    service { $name:
      ensure     => 'running',
      hasrestart => true,
    }
  }
}
