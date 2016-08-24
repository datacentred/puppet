devices = Dir.entries('/sys/class/block').select{ |x| x.start_with?('md') }
unless devices.empty?
  Facter.add('software_raid') do
    confine :kernel => :linux
    setcode do
      devices
    end
  end
end
