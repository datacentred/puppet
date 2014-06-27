# Class: dc_profile::wordpress::datacentred
#
# Setup wordpress for the customer-facing website www.datacentred.co.uk
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_profile::wordpress::datacentred {

  # Database parameters
  $datacentred_db_name = hiera(wordpress::datacentred_db_name)
  $datacentred_db_user = hiera(wordpress::datacentred_db_user)
  $datacentred_db_pass = hiera(wordpress::datacentred_db_pass)
  $datacentred_db_host = hiera(wordpress::datacentred_db_host)

  # Server parameters
  $datacentred_vhost        = 'www.datacentred.co.uk'
  $datacentred_server_names = ['www.datacentred.co.uk', 
                               'datacentred.co.uk', 
                               'www0.datacentred.co.uk']

  class { 'dc_wordpress':
    wordpress_vhost        => $datacentred_vhost,
    wordpress_server_names => $datacentred_server_names,
    wordpress_db_user      => $datacentred_db_user,
    wordpress_db_pass      => $datacentred_db_pass,
    wordpress_db_host      => $datacentred_db_host,
    wordpress_db_name      => $datacentred_db_name,
  }
}