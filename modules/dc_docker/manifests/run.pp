# == Class: ::dc_docker::run
#
# Wrapper class which handles running containers in a DataCentred fashion
# This basically means:
#   * Container logging is handled locally by syslog
#   * Host networking
#
define dc_docker::run (
  $image,
  $volumes = undef,
  $default_params = [
    '--network=host',
    '--log-driver=syslog',
    '--log-opt syslog-address=udp://127.0.0.1:514',
    '--log-opt syslog-facility=daemon',
    "--log-opt tag=${name}",
  ],
  $extra_params = undef,
) {

  docker::run { $name:
    image            => $image,
    volumes          => $volumes,
    extra_parameters => concat($default_params, $extra_params),
  }

}
