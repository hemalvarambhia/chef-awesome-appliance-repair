require_relative "../spec_helper.rb"

describe "chef-awesome-appliance-repair::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  describe "Web server set up" do
    it "installs apache web server" do
      expect(chef_run).to include_recipe "chef-awesome-appliance-repair::web_server"
    end
  end

  describe "Setting up the application database" do
    it "installs and configures MySQL" do
      expect(chef_run).to include_recipe "chef-awesome-appliance-repair::database"
    end
  end

  describe "Application frameworks and tools" do
    it "installs unzip" do
      expect(chef_run).to install_package "unzip"
    end

    it "installs python pip" do
      expect(chef_run).to install_package "python-pip"
    end

    it "installs Flask" do
      expect(chef_run).to install_python_pip "Flask"
    end

    context "on Ubuntu" do
      it "installs the Python WSGI adapter module for Apache" do
        expect(chef_run).to install_package "libapache2-mod-wsgi"
      end

      it "installs the python MySQL client library" do
        expect(chef_run).to install_package "python-mysqldb"
      end
    end

    context "on CentOS" do
       let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.4").converge(described_recipe) }

      it "installs the Python WSGI adapter module for Apache" do
        expect(chef_run).to install_package "mod_wsgi"
      end

      it "installs the python MySQL client library" do
        expect(chef_run).to install_package "MySQL-python"
      end
    end
  end

  describe "Application deployment" do
    it "downloads the application archive from github" do
      expect(chef_run).to create_remote_file("AAR_master.zip").with(source: "https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip")
    end

    it "copies the contents of the application to /var/www" do
      expect(chef_run).to run_execute("mv Awesome-Appliance-Repair-master/AAR /var/www")
    end

    it "gracefully restarts apache" do
      expect(chef_run).to run_execute("apachectl graceful")
    end
  end
end
