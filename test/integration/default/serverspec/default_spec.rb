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

describe package("unzip") do
 it { should be_installed }
end

# Python WSGI adapter module for Apache
describe package("libapache2-mod-wsgi") do
 it { should be_installed }
end

describe package("python-pip") do
 it { should be_installed }
end
