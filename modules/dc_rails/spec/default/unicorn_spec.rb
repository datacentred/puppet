require 'spec_helper'

describe service('unicorn') do
  it { should be_enabled.with_level(3)   }
  it { should be_running   }
end

describe file('/var/run/rails/soleman/unicorn.sock') do
  it { should be_socket }
end

# This file contains secrets
describe file('/etc/default/unicorn_soleman') do
  it { should be_owned_by 'rails' }
  it { should be_mode 600 }
end