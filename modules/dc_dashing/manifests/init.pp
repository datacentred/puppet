#Class: dc_dashing
#
# Install and configure Dashing sinatra server, and dashboards
class dc_dashing {

  class{ 'dc_dashing::install': } ->
  class{ 'dc_dashing::config': } ->
  class{ 'dc_dashing::service': }

}
