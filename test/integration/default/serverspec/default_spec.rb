require 'serverspec'

set :backend, :exec

describe package("apache2") do
 it { should be_installed }
end

describe service("apache2") do
 it { should be_enabled }
 it { should be_running }
end

describe package("mysql-server") do
 it { should be_installed }
end

describe service("mysql") do
 it { should be_enabled }
 it { should be_running }
end
