# Class: dc_rails::monitoring
#
# Specialised monitoring for a Rails application
#
class dc_rails::monitoring {
  include ::newrelic::server::linux
}
