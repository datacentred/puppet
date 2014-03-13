#!/usr/bin/env ruby1.9.3

#
# This script pulls a preseed configuration down from Foreman and adds the
# appropriate bits of configuration in order for the Packer build to succeed.
#

require 'net/http'
require 'openssl'

# URL for the preseed template used to build Foreman itself
preseed_uri = URI('https://foreman.<%= @domain -%>/unattended/provision?hostname=foreman.sal01.datacentred.co.uk')

# Filesystem location for the VMware / VirtualBox / Vagrant specific preseed bits
preseed_vagrant = "/home/packer/templates/vagrant.cfg"

# Output filename
preseed_output = "/home/packer/http/preseed.cfg"

# Function to grab the preseed configuration file via HTTPS
def get_page(uri)
  username = 'packer'
  password = '<%= @packer_pass -%>'
  Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
    request = Net::HTTP::Get.new uri.request_uri
    request['Accept']=("application/json,version=2")
    request.basic_auth username, password
    response = http.request request
    @page = response.body
  end
  return @page
end

# Build our new preseed configuration.  We have to remove some of the settings
# from our build (otherwise this will interrupt the provisioning process, as
# well as appending some Vagrant-related specifics.
preseed = get_page(preseed_uri).gsub(/(.*late_command.*)|(.*make-user.*)|(.*root-password.*)|(.*root-login.*)/,'') << File.read(preseed_vagrant)
File.open(preseed_output, 'w') {|f| f.write(preseed)}
