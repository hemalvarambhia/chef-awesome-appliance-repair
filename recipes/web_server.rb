Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::ApacheCommands)

package node[:apache][:package] do
  action :install
end

if platform?("centos")
  include_recipe "iptables::default"
  iptables_rule "ssh"
  iptables_rule "http"
end

group "www-data" do
  action :create
end

user "www-data" do
  gid "www-data"
  action :create
end

service node[:apache][:service] do
  action [:enable, :start]
end

cookbook_file "#{node[:apache][:conf_dir]}/AAR-apache.conf" do
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