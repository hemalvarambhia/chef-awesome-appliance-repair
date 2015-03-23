require_relative "../spec_helper"

describe "chef-awesome-appliance-repair::web_server" do
  context "on Ubuntu" do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it "installs apache2" do
      expect(chef_run).to install_package "apache2"
    end

    it "enables and starts apache2" do
      expect(chef_run).to enable_service "apache2"
      expect(chef_run).to start_service "apache2"
    end

    it "creates the apache config file to serve the web app" do
      expect(chef_run).to create_cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf"
      apache_config_file = chef_run.cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf"
      expect(apache_config_file).to notify("service[apache2]").to(:restart)
    end

    it "disables the default enabled site" do
      Chef::Resource::Execute.any_instance.stub(:enabled?).with("000-default").and_return(true)
      expect(chef_run).to run_execute "a2dissite default"
    end

    it "sets ownership of the /var/www/ directory to Apache" do
      expect(chef_run).to create_directory("/var/www/").with(owner: "www-data", group: "www-data")
    end
  end

  context "on CentOS" do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.4").converge(described_recipe) }

    it "installs apache" do
      expect(chef_run).to install_package "httpd"
    end

    it "creates the apache config file to serve the web app" do
      expect(chef_run).to create_cookbook_file "/etc/httpd/conf.d/AAR-apache.conf"
      apache_config_file = chef_run.cookbook_file "/etc/httpd/conf.d/AAR-apache.conf"
      expect(apache_config_file).to notify("service[httpd]").to(:restart)
    end

    it "enables and starts apache" do
      expect(chef_run).to enable_service "httpd"
      expect(chef_run).to start_service "httpd"
    end
  end
end