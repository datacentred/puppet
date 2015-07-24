# Class: dc_profile::log::dashing
#
# Install Dashing and dashes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::dashing {
  include apache
  include dc_dashing

  #Apache vhost config, proxies http requests to dashing server instance
  apache::vhost{ 'dashing':
    servername => "dashing.${::domain}",
    docroot    => '/opt/dashing/',
    port       => '80',
    priority   => '000',
    proxy_pass => [
      {
        'path'         => '/' ,
        'url'          => 'http://127.0.0.1:3030',
        'reverse_urls' =>  ['/', 'http://127.0.0.1:3030' ]
      },
    ],
    rewrites   => [
      {
        comment      => 'dashing rewrite',
        rewrite_cond => ['%{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f'],
        rewrite_rule => ['.* http://127.0.0.1:3030%{REQUEST_URI} [P,QSA]']
      }
    ]
  }

  @@dns_resource { "dashing.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
