Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::ApacheCommands)

package node[:apache][:package] do
  action :install
end

service node[:apache][:service] do
  action [:enable, :start]
end

directory "#{node[:apache][:dir]}/sites-available" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

directory "#{node[:apache][:dir]}/sites-enabled" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

cookbook_file "#{node[:apache][:dir]}/sites-enabled/AAR-apache.conf" do
  notifies :reload, "service[#{node[:apache][:service]}]"
  action :create
end

execute "a2dissite default" do
  only_if { enabled?("000-default") }
  notifies :reload, "service[#{node[:apache][:service]}]"
  action :run
end

directory("/var/www/") do
  owner "www-data"
  group "www-data"
  action :create
end