require_relative "../spec_helper.rb"

describe "chef-awesome-appliance-repair::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs apache2" do
    expect(chef_run).to install_package "apache2"
  end

  it "creates the apache config file to serve the web app" do
    expect(chef_run).to create_template("/etc/apache2/sites-enabled/AAR-apache.conf")
  end

  it "installs MySQL server" do
    expect(chef_run).to install_package "mysql-server"
  end  

  it "installs the MySQL server client" do
    expect(chef_run).to install_package "mysql-client"
  end

  it "installs unzip" do
    expect(chef_run).to install_package "unzip"
  end

  it "installs the Python WSGI adapter module for Apache" do
    expect(chef_run).to install_package "libapache2-mod-wsgi"
  end

  it "install python pip" do
    expect(chef_run).to install_package "python-pip"
  end

  it "installs the python MySQL client library" do
    expect(chef_run).to install_package "python-mysqldb"
  end

  it "installs Flask" do
    expect(chef_run).to install_python_pip "Flask"
  end

  it "creates a directory for the web app that is owned by Apache" do
    expect(chef_run).to create_directory("/var/www/AAR").with(owner: "www-data", group: "www-data")
  end
end
