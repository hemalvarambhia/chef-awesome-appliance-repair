Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::MySQLCommands)

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
  not_if { permissions_granted? }
  action :run
end