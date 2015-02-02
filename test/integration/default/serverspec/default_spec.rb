require 'serverspec'

set :backend, :exec

describe package("apache2") do
 it { should be_installed }
end

describe service("apache2") do
 it { should be_enabled }
 it { should be_running }
end

describe file("/etc/apache2/sites-enabled/AAR-apache.conf") do
 it { should be_file }
end

describe package("mysql-server") do
 it { should be_installed }
end

describe service("mysql") do
 it { should be_enabled }
 it { should be_running }
end

describe package("mysql-client") do
 it { should be_installed }
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

describe package("python-mysqldb") do
 it { should be_installed }
end

describe command("pip freeze | grep Flask") do
 its(:stdout) do
  should match /Flask/
 end
end

describe file("/var/www/AAR") do
 it { should be_directory }
 it { should be_owned_by "www-data" }
 it { should be_grouped_into "www-data" }
end
