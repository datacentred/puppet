class dc_collectd::agent::df {

  # convert root
  $df_array_root = regsubst(split($::mounts, ','), '^/$', 'root')
  # now convert all the slashes to underscores
  # These then need converting to dashes in the gdash template
  $df_array_convert = regsubst($df_array_root, '/', '_', 'G')

  $dfhashhost = suffix($df_array, "#${::hostname}")

  @@dc_gdash::df { $dfhashhost: }

}

