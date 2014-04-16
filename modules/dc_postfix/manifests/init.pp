# Class: dc_postfix
#
# Installs postfix
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_postfix (
  $gateway    = undef,
  $nullclient = undef,
) {

  if $gateway and $nullclient {
      fail('enabling both the $gateway and $nullclient parameters is not supported. Please disable one.')
  }

  if ! $gateway and ! $nullclient {
      fail('must specify one of $gateway or $nullclient')
  }

  if $gateway {
    include ::dc_postfix::gateway
  }

  if $nullclient {
    include ::dc_postfix::nullclient
  }

}
