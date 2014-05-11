# Returns a comma seperated list of cpu numbers
if Facter.value(:kernel) == 'Linux'
    # We store a list of cpu's here ...
    cpus = []
    Facter::Util::Resolution.exec('grep processor /proc/cpuinfo | cut -d ":" -f 2 2> /dev/null').each_line do |line|
        # Remove bloat ...
        line.strip!
            cpus << line
        end
    Facter.add('cpunumbers') do
    confine :kernel => :linux
    setcode { cpus.join(',') }
    end
end

