Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)
Chef::Resource::RemoteFile.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)

case node[:platform]
  when "ubuntu"
    include_recipe "apt::default"
  when "centos"
    include_recipe "yum-epel::default"
end

include_recipe "chef-awesome-appliance-repair::web_server"

include_recipe "chef-awesome-appliance-repair::database"

package "python-pip" do
 action :install
end

python_pip "Flask" do
 action :install
end

package "unzip" do
 action :install
end

python_mysql_lib = case node[:platform]
                    when "ubuntu"
                     "python-mysqldb"
                    when "centos"
                     "MySQL-python"
                   end
package python_mysql_lib do
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
