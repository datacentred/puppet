require 'resolv'
 
module Puppet::Parser::Functions
  newfunction(:get_ip_addr, :type => :rvalue) do |args|
    hostname = args[0].strip
    begin
      Resolv.getaddress hostname
    rescue Resolv::ResolvError
      return ''
    end
  end
end
