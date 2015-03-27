# Dynamically determine the platform type
Facter.add(:platform) do

  confine :kernel => "Linux"

  setcode do
    # Accounts we care about
    # NOTE: Must be mutually exclusive
    accounts = [ 'vagrant', 'ubuntu' ]
    # Grab all users on the system
    users = []
    File.open('/etc/passwd') do |f|
      f.each do |line|
        users.push line.split(':').first
      end
    end
    # Perform a boolean intersection and return
    # the first match or nil
    (users & accounts).first
  end

end
