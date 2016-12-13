# == Class: llama 
#
# This class installs/configures/manages a llama collector, reflector or both
#
# === Parameters
#
# [*llama_basedir*]
#   String. Base directory for llama. Default '/opt/llama'
#
# [*llama_collector_confdir*]
#   String. Default '/opt/llama/etc/'
#
# [*llama_repo_source*]
#   String. Default 'https://github.com/dropbox/llama' 
#
# [*llama_is_reflector*]
#   Boolean.  Whether to setup the reflector.  Default false
#
# [*llama_reflector_bindport*]
#   Integer.  Default 60000 
#
# [*llama_reflector_loglevel*]
#   String.   Default 'info' 
#
# [*llama_reflector_logfile*]
#   String.   Default '/var/log/llama_reflector.log' 
#
# [*llama_is_collector*]
#   Boolean.  Whether to setup the collector.  Default false
#
# [*llama_collector_loglevel*]
#   String.   Default 'info'
#
# [*llama_collector_logfile*]
#   String.   Default '/var/log/llama_collector.log' 
#
# [*llama_collector_count*]
#   Integer.  Default 128
#
# [*llama_collector_interval*]
#   Integer.  Default 30 
#
# [*llama_collector_http_bindip*]
#   String.   Default '0.0.0.0' 
#
# [*llama_collector_http_bindport*]
#   Integer.  Default 5000 
#
# [*llama_collector_use_udp*]
#   Boolean.  Default true 
#
# [*llama_collector_config*]
#   String.   Default undef 
#

class llama (
  $llama_basedir = '/opt/llama',
  $llama_collector_confdir = '/opt/llama/etc',
  $llama_repo_source = 'https://github.com/dropbox/llama',
  $llama_is_reflector = true,
  $llama_reflector_bindport = '60000',
  $llama_reflector_loglevel = 'info',
  $llama_reflector_logfile = '/var/log/llama_reflector.log',
  $llama_is_collector = false,
  $llama_collector_loglevel = 'info',
  $llama_collector_logfile = '/var/log/llama_collector.log',
  $llama_collector_count = 128,
  $llama_collector_interval = 30,
  $llama_collector_http_bindip = '0.0.0.0',
  $llama_collector_http_bindport = '5000',
  $llama_collector_use_udp = false,
  $llama_collector_config = undef,
) {

    include ::llama::repo
    include ::llama::install
    include ::llama::configure
    include ::llama::service

    Class['::llama::repo'] ->
    Class['::llama::install'] ->
    Class['::llama::configure'] ~>
    Class['::llama::service']

}
