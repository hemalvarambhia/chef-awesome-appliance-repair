Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::MySQLCommands)
Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)
Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::ApacheCommands)
Chef::Resource::RemoteFile.send(:include, ChefAwesomeApplianceRepairHelper::GeneralCommands)

include_recipe "apt::default"

include_recipe "chef-awesome-appliance-repair::web_server"

package "mysql-server" do
 action :install
end

package "mysql-client" do
 action :install
end

cookbook_file "make_AARdb.sql" do
  action :create
end

execute "create-AARdb" do
  command "mysql -u root < make_AARdb.sql"
  not_if { database_exists? }
  action :run
end

execute "create-AARdb-user" do
  command "mysql -u root -e \"CREATE USER 'aarapp'@'localhost' IDENTIFIED BY 'aar_db_password'\""
  not_if { user_exists? }
  action :run
end

execute "mysql -u root -e \"GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on AARdb.* to aarapp@localhost\"" do
  action :run
end

package "unzip" do
 action :install
end

package "libapache2-mod-wsgi" do
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
