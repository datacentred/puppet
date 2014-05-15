class dc_gdash::params {
  $graphite_server = hiera(graphite_server)
  $whisper_root = '/var/opt/graphite/storage/whisper'
  $reversedomain = join(reverse(split(${::domain}, '.')),'.')
}
