# Class: dc_rails::ruby
#
# Configure Ruby and related dev packages
#
class dc_rails::ruby {
  include ::ruby
  include ::ruby::dev

  $deps = ['git-core',             'curl',            'zlib1g-dev',
          'libssl-dev',           'libreadline-dev', 'libyaml-dev',
          'libmysqlclient-dev',   'libxml2-dev',     'libxslt1-dev',
          'libcurl4-openssl-dev', 'libffi-dev',      'build-essential']

  ensure_packages($deps)
}
