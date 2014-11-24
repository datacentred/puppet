# Class:
#
# Configures the icinga commands not defined in core plugins
#
# Parameters:
#
# $cfg_path
#     Specifies where the nagios configuration files should be generated
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::nagios_commands {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_icinga_password = hiera(keystone_icinga_password)
  $keystone_icinga_user = hiera(keystone_icinga_user)
  $keystone_icinga_tenant = hiera(keystone_icinga_tenant)
  $keystone_port = hiera(keystone_port)
  $nova_osapi_port = hiera(nova_osapi_port)
  $glance_api_port = hiera(glance_api_port)
  $cinder_api_port = hiera(cinder_api_port)
  $foreman_icinga_pw = hiera(foreman_icinga_pw)
  $rabbitmq_monuser = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password)
  $mariadb_icinga_pw = hiera(mariadb_icinga_pw)
  $ldap_server_suffix = hiera(ldap_suffix)
  $haproxy_stats_user = hiera(haproxy_stats_user)
  $haproxy_stats_password = hiera(haproxy_stats_password)


  ######################################################################
  # Commands
  ######################################################################
  # Define custom commands not provided by nagios-plugins
  ######################################################################

  icinga::command { 'notify-service-by-pagerduty':
    command_line => '/usr/share/pdagent-integrations/bin/pd-nagios -n service -k $CONTACTPAGER$ -t "$NOTIFICATIONTYPE$" -f SERVICEDESC="$SERVICEDESC$" -f SERVICESTATE="$SERVICESTATE$" -f HOSTNAME="$HOSTNAME$" -f SERVICEOUTPUT="$SERVICEOUTPUT$"',
  }

  icinga::command { 'notify-host-by-pagerduty':
    command_line => '/usr/share/pdagent-integrations/bin/pd-nagios -n host -k $CONTACTPAGER$ -t "$NOTIFICATIONTYPE$" -f HOSTNAME="$HOSTNAME$" -f HOSTSTATE="$HOSTSTATE$"',
  }

  icinga::command { 'notify-host-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$',
  }

  icinga::command { 'notify-service-by-email':
    command_line => '/usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
  }

  icinga::command { 'check_pgsql_dc':
    command_line => '/usr/lib/nagios/plugins/check_pgsql -H $HOSTADDRESS$ -d $ARG1$ -l $ARG2$ -p $ARG3$',
  }

  icinga::command { 'check_ntp_dc':
    command_line => '/usr/lib/nagios/plugins/check_ntp_time -H $HOSTADDRESS$',
  }

  icinga::command { 'check_foreman_proxy_dc':
    command_line => '/usr/lib/nagios/plugins/check_http -H $HOSTADDRESS$ --ssl -p 8443 -u /version',
  }

  icinga::command { 'check_tftp_dc':
    command_line => '/usr/lib/nagios/plugins/check_tftp -H $HOSTADDRESS$ -p nagios_test_file',
  }

  icinga::command { 'check_mysql_dc':
    command_line => "/usr/lib/nagios/plugins/check_mysql -H \$HOSTADDRESS$ -u icinga -p ${mariadb_icinga_pw}",
  }

  icinga::command { 'check_nfs_dc':
    command_line => '/usr/lib/nagios/plugins/check_rpc -H $HOSTADDRESS$ -C nfs -c2,3,4',
  }

  icinga::command { 'check_keystone_dc':
    command_line => "/usr/lib/nagios/plugins/check_keystone --auth_url http://\$HOSTADDRESS\$:5000/v2.0 --username icinga --password ${keystone_icinga_password} --tenant icinga"
  }

  icinga::command { 'check_nova_ec2_api':
    command_line => "/usr/lib/nagios/plugins/check_http -u /services/Cloud/ -e 400 -H \$HOSTADDRESS$ -p 8773"
  }

  icinga::command { 'check_nova_os_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8774"
  }

  icinga::command { 'check_nova_os_metadata_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8775"
  }

  icinga::command { 'check_nova_instance':
    command_line => "/usr/lib/nagios/plugins/cache_check.py -c \"/usr/lib/nagios/plugins/check_nova-instance.py --auth_url https://\$HOSTALIAS\$:${keystone_port}/v2.0 --endpoint_url https://\$HOSTALIAS\$:${nova_osapi_port}/v2 --tenant ${keystone_icinga_tenant} --username ${keystone_icinga_user} --password ${keystone_icinga_password} --instance_name icinga --image_name CirrOS\\ 0.3.3 --flavor_name m1.tiny --force_delete\" -e 900 -t 180 -i 600"
  }

  icinga::command { 'check_nova_api_connect':
    command_line => "/usr/lib/nagios/plugins/check_nova-api.sh -H https://\$HOSTALIAS\$:${keystone_port}/v2.0 -E https://\$HOSTALIAS\$:${nova_osapi_port}/v2 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}"
  }

  icinga::command { 'check_neutron_api':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9696"
  }

  icinga::command { 'check_rabbitmq_aliveness':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_aliveness -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_server':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_server -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_overview':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_overview -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_watermark':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_watermark -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_partition':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_partition -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTNAME$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_shovels':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_shovels -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_queue':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_queue -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_rabbitmq_objects':
    command_line => "/usr/lib/nagios/plugins/check_rabbitmq_objects -u ${rabbitmq_monuser} -p ${rabbitmq_monuser_password} -H \$HOSTADDRESS$ --port=15672"
  }

  icinga::command { 'check_glance_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 9292"
  }

  icinga::command { 'check_glance_registry_http':
    command_line => "/usr/lib/nagios/plugins/check_http -e 401 -H \$HOSTADDRESS$ -p 9191"
  }

  icinga::command { 'check_glance_api_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8776"
  }

  icinga::command { 'check_glance_api_connect':
    command_line => "/usr/lib/nagios/plugins/check_glance-api.sh -H https://\$HOSTALIAS\$:${keystone_port}/v2.0 -E https://\$HOSTALIAS\$:${glance_api_port}/v1 -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}"
  }

  icinga::command { 'check_dc_ldap':
    command_line => "/usr/lib/nagios/plugins/check_ldap -H \$HOSTADDRESS$ -b ${ldap_server_suffix}"
  }

  icinga::command { 'check_cinder_api_http':
    command_line => "/usr/lib/nagios/plugins/check_http -H \$HOSTADDRESS$ -p 8776"
  }

  icinga::command { 'check_cinder_volume':
    command_line => "/usr/lib/nagios/plugins/cache_check.py -c \"/usr/lib/nagios/plugins/check_cinder-volume.py --auth_url https://\$HOSTALIAS\$:${keystone_port}/v2.0 --endpoint_url https://\$HOSTALIAS\$:${cinder_api_port}/v1 --tenant ${keystone_icinga_tenant} --user ${keystone_icinga_user} --password ${keystone_icinga_password}\" -e 900 -t 180 -i 600"
  }

  icinga::command { 'check_cinder_api_connect':
    command_line => "/usr/lib/nagios/plugins/check_cinder-api.sh -H https://\$HOSTALIAS\$ -T ${keystone_icinga_tenant} -U ${keystone_icinga_user} -P ${keystone_icinga_password}"
  }

  icinga::command { 'check_haproxy':
    command_line => "sudo /usr/lib/nagios/plugins/check_haproxy.rb -u \"https://\$HOSTALIAS\$:1936/\" -U ${haproxy_stats_user} -P ${haproxy_stats_password} -C /var/lib/puppet/ssl/certs/ca.pem"
  }

  icinga::command { 'check_es_updating':
    command_line => "/usr/lib/nagios/plugins/es_data_updating_check.rb -H \$HOSTADDRESS$ -p 9200"
  }

}

