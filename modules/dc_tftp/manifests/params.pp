class dc_tftp::params (
  $tftp_dir,
  $virtual_address,
  $virtual_netmask,
  $virtual_router_id,
  $ha_sync,
  $sync_master,
  $sync_slave,
  $use_inetd,
  $tftp_sync_user,
  $tftp_sync_group,
  $tftp_sync_home,
  $tftp_user,
  $tftp_group,
  $dir_mode,
){

 case $lsbdistcodename { 
  'trusty' : { $conf_template = 'dc_tftp/lsyncd.conf.lua.trusty.erb' }
  'precise': { $conf_template = 'dc_tftp/lsyncd.conf.lua.precise.erb' }
 }

 $address = $::ipaddress
 
}

