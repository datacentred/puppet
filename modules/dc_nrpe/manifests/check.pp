# == Define: dc_nrpe::check
#
define dc_nrpe::check (
  $path,
  $source = undef,
  $content = undef,
  $args = '',
  $sudo = false,
) {

  validate_absolute_path($path)
  validate_string($source)
  validate_string($args)
  validate_bool($sudo)

  if $source and $content {
    fail ('only one of $source and $content can be defined')
  }

  # Enable privilige escalation for the command
  if $sudo {
    sudo::conf { $name:
      priority => 10,
      content  => "nagios ALL=NOPASSWD:${path}",
    }
    $sudo_command = 'sudo '
  } else {
    $sudo_command = ''
  }

  # Install the check
  if $source {
    file { $path:
      ensure => file,
      source => $source,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $content {
    file { $path:
      ensure => file,
      content => $content,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  # Create the check
  $command = "command[${name}]=${sudo_command}${path} ${args}\n"

  concat::fragment { $name:
    target  => '/etc/nagios/nrpe.d/dc_nrpe_check.cfg',
    content => $command,
  }

}
