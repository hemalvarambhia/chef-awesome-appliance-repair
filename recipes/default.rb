Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)
Chef::Resource::RemoteFile.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)

include_recipe "apt::default"

include_recipe "chef-awesome-appliance-repair::web_server"

include_recipe "chef-awesome-appliance-repair::database"
apache_wsgi_module = case node[:platform]
                      when "ubuntu"
                        "libapache2-mod-wsgi"
                      when "centos"
                        "mod_wsgi"
                     end 
package apache_wsgi_module do
 action :install
end

package "python-pip" do
 action :install
end

package "python-mysqldb" do
 action :install
end

python_pip "Flask" do
 action :install
end

package "unzip" do
 action :install
end

remote_file "AAR_master.zip" do
  source "https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip"
  not_if { application_exists? }
  action :create
end

execute "unzip AAR_master.zip" do
  not_if { application_exists? }
  action :run
end

execute "mv Awesome-Appliance-Repair-master/AAR /var/www" do
  not_if { application_exists? }
  action :run
end

directory "/var/www/AAR" do
 owner "www-data"
 group "www-data"
 action :create
end

template "/var/www/AAR/AAR_config.py" do
  variables aar_db_password: node[:aar_db_password], secret_key: node[:aar_secret_key]
  action :create
end

execute "apachectl graceful" do
  action :run
end
