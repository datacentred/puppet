# Get the NTP server configured for the system
Facter.add(:ntp) do
  setcode do
    # Try to read in the server lines from ntp.conf
    begin
      servers = File.readlines('/etc/ntp.conf').select{|x| x.match(/^server\s+\S+.*$/)}
    rescue Errno::ENOENT, NoMethodError
      servers = nil
    end

    {
      # Return a sane default if nothing is configured
      servers: servers && servers.map{|x| x.split[1]} || ['1.uk.pool.ntp.org']
    }
  end
end
