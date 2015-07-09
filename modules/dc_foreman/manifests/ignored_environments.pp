# == Class: dc_foreman::ignored_environments
#
# Ignore puppet classes based on regular expressions
#
# === Parameters
#
# [*regexes*]
#   List of regular expressions matching puppet classes to omit from
#   foreman.  Defaults to all the things
#
class dc_foreman::ignored_environments (
  $regexes = [
    '/.*/',
  ],
) {

  file { '/usr/share/foreman/config/ignored_environments.yml':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_foreman/ignored_environments.yml.erb'),
  }

}
