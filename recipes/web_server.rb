Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::ApacheCommands)

package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end

cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf" do
  notifies :reload, "service[apache2]"
  action :create
end

execute "a2dissite default" do
  only_if { enabled?("000-default") }
  notifies :reload, "service[apache2]"
  action :run
end

directory("/var/www/") do
  owner "www-data"
  group "www-data"
  action :create
end