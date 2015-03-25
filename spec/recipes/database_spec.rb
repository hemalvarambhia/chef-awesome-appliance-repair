require_relative "../spec_helper"

describe "chef-awesome-appliance-repair::database" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs MySQL server" do
    expect(chef_run).to install_package "mysql-server"
  end

  it "copies over the application database creation script" do
    expect(chef_run).to create_cookbook_file("make_AARdb.sql")
  end

  it "creates the AAR's relational database" do
    expect(chef_run).to run_execute("create-AARdb").with(command: "mysql -u root < make_AARdb.sql")
  end

  it "creates the application database user" do
    expect(chef_run).to run_execute("create-AARdb-user").with(command: "mysql -u root -e \"CREATE USER 'aarapp'@'localhost' IDENTIFIED BY '#{chef_run.node[:aar_db_password]}'\"")
  end

  it "grants aarapp SELECT, CREATE, DELETE and UPDATE privileges on AARdb" do
    expect(chef_run).to run_execute("mysql -u root -e \"GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on AARdb.* to aarapp@localhost\"")
  end

  context "on Ubuntu" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "12.04").converge(described_recipe) }
    it "installs client package 'mysql-client'" do
      expect(chef_run).to install_package "mysql-client"
    end
  end

  context "on CentOS" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.4").converge(described_recipe) }

    it "installs client package 'mysql'" do
      expect(chef_run).to install_package "mysql"
    end
  end
end
