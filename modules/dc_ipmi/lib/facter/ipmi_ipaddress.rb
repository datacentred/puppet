require 'facter'
Facter.add(:ipmi_ipaddress) do
  confine :boardmanufacturer => 'Supermicro'
  setcode do
    output = `ipmitool lan print`
    match = /^IP Address\s*:\s*([\w\.]+)/.match(output)
    match ? match[1] : "undefined"
  end
end
