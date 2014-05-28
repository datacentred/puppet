# Class: dc_logstash::client::mail
#
# Forwards the mail error logs
#
class dc_logstash::client::mail {
  
  dc_logstash::client::register { 'mail_error':
    logs => '/var/log/mail.err',
    type => 'mail_error',
  }

}
