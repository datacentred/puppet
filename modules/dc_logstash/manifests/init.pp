# Class: dc_logstash
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
class dc_logstash {

# Basic class for installing Logstash and subsequent configuration for parsing events
# fed via rsyslog from other hosts.

  class { '::logstash':
    provider     => 'custom',
    java_install => true,
    # No packages provided so we just install the JAR, currently 'mirrored' onto mirror.sal01...
    jarfile      => 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar',
  }

  # UDP listener
  # This handles messages from rsyslog sent in formatted natively for Logstash's
  # consumption using JSON.
  logstash::input::udp { 'logstash-udp':
    format => 'json_event',
    port   => 55514,
    type   => 'rsyslog',
  }

  # Syslog listener for network devices
  logstash::input::syslog { 'logstash-syslog':
    type => 'syslog',
    port => hiera(logstash_syslog_port),
  }

  # Setup default embedded ElasticSearch instance
  logstash::output::elasticsearch { 'logstash-elasticsearch':
    embedded => true,
  }

  # Email alerting from rsyslog
  # Currently the logstash module only supports match, which is deprecated in favour of conditionals
  logstash::output::email { 'logstash-rsyslog-email':
    from    => "logstash@{::$fqdn}",
    match   => [
                "WARN","syslog_severity_code,4",
                "ERROR","syslog_severity_code,3",
                "CRITICAL","syslog_severity_code,2",
                "ALERT","syslog_severity_code,1",
                "EMERGENCY","syslog_severity_code,0",
               ],
    subject => '%{matchName}',
    to      => hiera(sysmailaddress),
    via     => 'sendmail',
    body    => "Here is the event line that occured: %{@message}",
  }

  class { 'dc_logstash::icinga': }

}
