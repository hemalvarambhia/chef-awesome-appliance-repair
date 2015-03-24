require 'serverspec'

set :backend, :exec

describe "Web server set up" do
  describe package("httpd") do
    it { should be_installed }
  end

  describe package "mod_wsgi" do
    it { should be_installed }
  end

  describe group("www-data") do
    it { should exist }
  end

  describe user("www-data") do
    it { should exist }
    it { should belong_to_group "www-data" }
  end

  describe service("httpd") do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
   it { should be_listening }
  end

  describe file("/etc/httpd/conf.d/AAR-apache.conf") do
    it { should be_file }
  end

  describe file("/var/www/") do
    it { should be_directory }
    it { should be_owned_by "www-data" }
    it { should be_grouped_into "www-data" }
  end
end

describe "Database set up" do
  describe package("mysql-server") do
   it { should be_installed }
  end

  describe service("mysqld") do
   it { should be_enabled }
   it { should be_running }
  end

  describe package("mysql") do
   it { should be_installed }
  end

  describe command("mysql -u root -e \"SHOW DATABASES LIKE 'AARdb'\"") do
    its(:stdout) {
      should match /AARdb/
    }
  end

  describe command("mysql -u root -e \"SELECT User FROM mysql.user where user='aarapp'\"") do
    its(:stdout) {
      should match /aarapp/
    }
  end

  describe command("mysql -u root -e \"SHOW GRANTS FOR 'aarapp'@'localhost'\"") do
    its(:stdout) {
      should match /SELECT, INSERT, UPDATE, DELETE, CREATE ON `AARdb`.*/
    }
  end
end

describe "Application frameworks and tools" do
  describe package("unzip") do
   it { should be_installed }
  end

  describe package("python-pip") do
    it { should be_installed }
  end

  describe package("MySQL-python") do
    it { should be_installed }
  end

  describe command("pip freeze | grep Flask") do
    its(:stdout) do
      should match /Flask/
    end
  end
end

describe file("/var/www/AAR") do
 it { should be_directory }
 it { should be_owned_by "www-data" }
 it { should be_grouped_into "www-data" }
end

describe file("/var/www/AAR/AAR_config.py") do
  it { should be_file }
  its(:content) {
    should match /CONNECTION_ARGS = {\"host\":\"localhost\", "user":\"aarapp\", \"passwd\":\"aar_db_password\", \"db\":\"AARdb\"}/
  }
  its(:content) {
    should match /SECRET_KEY = \"secret_key\"/
  }
end

describe command("ls /var/www/AAR") do
  its(:stdout) {
    expected_contents = %w{AAR_config.py __init__.py awesomeapp.py awesomeapp.wsgi robots.txt static templates}.join("\n")
    should match /#{expected_contents}/
  }
end
