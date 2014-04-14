Facter.add(:ceph_devices) do
  confine :kernel => 'Linux'
  setcode do
    Dir.foreach('/dev').select { |node| /^sd[b-z]$/.match(node) }.join(',')
  end
end
