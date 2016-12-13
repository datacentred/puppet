# == Class: llama::service
#
# Ensures the llama collector service is running
#
class llama::service {

  assert_private()

  $_llama_is_collector = $::llama::llama_is_collector
  $_llama_is_reflector = $::llama::llama_is_reflector

  exec {
    'systemctl-daemon-reload':
      command     => 'systemctl daemon-reload',
      refreshonly => true,
  }

  if $_llama_is_collector {
    Exec['systemctl-daemon-reload'] ->

    service { 'llama_collector':
        ensure     => 'running',
        hasrestart => true,
      }
  }

  if $_llama_is_reflector {
    Exec['systemctl-daemon-reload'] ->

    service { 'llama_reflector':
      ensure     => 'running',
      hasrestart => true,
    }
  }
}
