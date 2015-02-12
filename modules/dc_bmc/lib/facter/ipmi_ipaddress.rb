Facter.add(:ipmi_ipaddress) do
  setcode do
    ipaddress = nil
    if output = Facter::Util::Resolution.exec('ipmitool lan print 2>&1')
      match = /^IP Address\s*:\s*([\w\.]+)/.match(output)
      ipaddress = match[1] unless match.nil?
    end
    ipaddress
  end
end
