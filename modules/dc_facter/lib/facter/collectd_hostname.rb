Facter.add(:collectd_hostname) do
    setcode do
        collectd_hostname = %x{hostname -f}.strip.split('.').reverse.join('.')
    end
end
