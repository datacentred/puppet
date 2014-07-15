# Class: dc_profile::mon::icinga_server
#
# Icinga server instance
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::icinga_server {

  contain apache
  contain apache::mod::php 
  contain php
  contain php::apache

  contain dc_icinga::server

  include dc_icinga::hostgroup_http

}
