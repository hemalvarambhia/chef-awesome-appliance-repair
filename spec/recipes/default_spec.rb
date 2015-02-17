require_relative "../spec_helper.rb"

describe "chef-awesome-appliance-repair::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs apache2" do
    expect(chef_run).to install_package "apache2"
  end

  it "creates the apache config file to serve the web app" do
    expect(chef_run).to create_cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf"
    apache_config_file = chef_run.cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf"
    expect(apache_config_file).to notify("service[apache2]").to(:reload)
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

  it "sets ownership of the /var/www/ directory to Apache" do
    expect(chef_run).to create_directory("/var/www/").with(owner: "www-data", group: "www-data")
  end

  it "creates a directory for the web app that is owned by Apache" do
    expect(chef_run).to create_directory("/var/www/AAR").with(owner: "www-data", group: "www-data")
  end

  it "copies over the application database creation script" do
    expect(chef_run).to create_cookbook_file("make_AARdb.sql")
  end

  it "creates the AAR's relational database" do
    expect(chef_run).to run_execute("create-AARdb").with(command: "mysql -u root < make_AARdb.sql")
  end
end
