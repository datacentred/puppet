class dc_collectd::agent::df {

  # convert root
  $df_array_root = regsubst(split($::mounts, ','), '^/$', 'root')
  # Remove leading slash altogether
  $df_array_deslash = regsubst($df_array_root, '^/', '')
  # now convert all the remaining slashes to underscores
  # These then need converting to dashes in the gdash template
  $df_array_convert = regsubst($df_array_deslash, '/', '_', 'G')

  $dfhashhost = suffix($df_array_convert, "#${::hostname}")

  @@dc_gdash::df { $dfhashhost: }

}

