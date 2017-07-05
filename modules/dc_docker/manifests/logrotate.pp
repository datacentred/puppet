# == Class: dc_docker::logrotate
#
# Logrotate functionality for containers deployed using this module
#
define dc_docker::logrotate (
  String $container = $title,
) {

  logrotate::rule { $container:
    path          => "/var/log/${container}/*.log",
    rotate        => 7,
    rotate_every  => 'day',
    compress      => true,
    delaycompress => true,
    missingok     => true,
    ifempty       => false,
    postrotate    => 'service rsyslog rotate > /dev/null',
  }

}
