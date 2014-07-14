Facter.add(:ipmi_ipaddress) do
  setcode do
    ipaddress = nil
    if output = Facter::Util::Resolution.exec('ipmitool lan print 2>&1')
      ipaddress = /^IP Address\s*:\s*([\w\.]+)/.match(output)[1]
    end
    ipaddress
  end
end
