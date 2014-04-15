require 'spec_helper'

describe package('mysqlserver') do
  it { should be_installed }
end

describe service('mysqld') do
  it { should be_enabled   }
  it { should be_running   }
end
