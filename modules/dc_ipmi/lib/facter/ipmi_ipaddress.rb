require 'facter'
Facter.add(:ipmi_ipaddress) do
  setcode do
    output = `sudo ipmitool lan print`
    match = /^IP Address\s*:\s*([\w\.]+)/.match(output)
    match[1]
  end
end
