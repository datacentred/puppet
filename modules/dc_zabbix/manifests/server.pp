# Class dc_zabbix::server
#
# Deploys Zabbix 3 server as well as two custom apache vhosts definitions.
# The first vhost is a simple http instance listening on port 80 which
# then redirects to the https vhosts.
# The https vhost is secured using client certs based on the puppet PKI.
# A zabbix agent is also installed on the box to allow for monitoring
# of itself.
# Firewall rules are maintained as part of this module.
#
class dc_zabbix::server (
  $zabbix_url                               = $dc_zabbix::params::zabbix_url,
  $apache_php_max_execution_time            = $dc_zabbix::params::apache_php_max_execution_time,
  $apache_php_memory_limit                  = $dc_zabbix::params::apache_php_memory_limit,
  $apache_php_post_max_size                 = $dc_zabbix::params::apache_php_post_max_size,
  $apache_php_upload_max_filesize           = $dc_zabbix::params::apache_php_upload_max_filesize,
  $apache_php_max_input_time                = $dc_zabbix::params::apache_php_max_input_time,
  $apache_php_always_populate_raw_post_data = $dc_zabbix::params::apache_php_always_populate_raw_post_data,
  $apache_php_max_input_vars                = $dc_zabbix::params::apache_php_max_input_vars,
  $apache_php_date_time                     = $dc_zabbix::params::apache_php_date_time,
  $firewall_enabled                         = $dc_zabbix::params::firewall_enabled,
  $firewall_rules                           = $dc_zabbix::params::firewall_rules,
) inherits ::dc_zabbix::params
{

    include ::apache
    include ::firewall
    include ::zabbix
    include ::zabbix::agent
    include ::apache::mod::php
    include ::apache::mod::ssl
    include ::postgresql::server

    $packages = [
      'iptables-persistent',
      'php-mbstring',
      'php-bcmath',
      'php-gd',
      'php',
      'libapache2-mod-php',
      'php-xml',
    ]

    ensure_packages($packages)

    if $firewall_enabled {
      if hiera('firewall::purge') {
          resources { 'firewall': purge => true }
      }
      create_resources(firewall, $firewall_rules['base'])
      create_resources(firewall, $firewall_rules['server'])
    }

    $directory_allow = { 'require' => 'all granted', }
    $directory_deny  = { 'require' => 'all denied', }
    $_key            = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
    $_cert           = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
    $_cacert         = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
    $_crl            = '/etc/puppetlabs/puppet/ssl/crl.pem'

    apache::vhost { "${::fqdn} nonssl":
      docroot        => '/usr/share/zabbix',
      manage_docroot => false,
      default_vhost  => true,
      port           => 80,
      servername     => $::fqdn,
      ssl            => false,
      rewrites       => [
        {
          comment      => 'redirect all to https',
          rewrite_cond => ['%{SERVER_PORT} !^443$'],
          rewrite_rule => ["^/(.*)$ https://${zabbix_url}/\$1 [L,R]"],
        }
      ],
    }

    apache::vhost { "${::fqdn} ssl":
      servername        => $zabbix_url,
      port              => 443,
      docroot           => '/usr/share/zabbix',
      ssl               => true,
      ssl_cert          => $_cert,
      ssl_key           => $_key,
      ssl_ca            => $_cacert,
      ssl_crl           => $_crl,
      ssl_verify_client => 'require',
      ssl_verify_depth  => 1,
      directories       => [
          merge({
            path     => '/usr/share/zabbix',
            provider => 'directory',
          }, $directory_allow),
          merge({
            path     => '/usr/share/zabbix/conf',
            provider => 'directory',
          }, $directory_deny),
          merge({
            path     => '/usr/share/zabbix/api',
            provider => 'directory',
          }, $directory_deny),
          merge({
            path     => '/usr/share/zabbix/include',
            provider => 'directory',
          }, $directory_deny),
          merge({
            path     => '/usr/share/zabbix/include/classes',
            provider => 'directory',
          }, $directory_deny),
      ],
      custom_fragment   => "
        php_value max_execution_time ${apache_php_max_execution_time}
        php_value memory_limit ${apache_php_memory_limit}
        php_value post_max_size ${apache_php_post_max_size}
        php_value upload_max_filesize ${apache_php_upload_max_filesize}
        php_value max_input_time ${apache_php_max_input_time}
        php_value always_populate_raw_post_data ${apache_php_always_populate_raw_post_data}
        php_value max_input_vars ${apache_php_max_input_vars}
        php_value date.timezone ${apache_php_date_time}",
      rewrites          => [
        {
          rewrite_rule => ['^$ /index.php [L]'] }
      ],
      before            => Class['::zabbix'],
    }
}
