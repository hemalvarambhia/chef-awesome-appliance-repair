require_relative "../spec_helper.rb"

describe "chef-awesome-appliance-repair::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs apache2" do
    expect(chef_run).to install_package "apache2"
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
end
