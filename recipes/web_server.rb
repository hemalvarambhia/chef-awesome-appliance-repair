Chef::Resource::Execute.send(:include, ChefAwesomeApplianceRepairHelper::ApacheCommands)
apache = case node[:platform]
           when "ubuntu"
             "apache2"
           when "centos"
             "httpd"
         end

package apache do
  action :install
end

service apache do
  action [:enable, :start]
end

cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf" do
  notifies :reload, "service[#{apache}]"
  action :create
end

execute "a2dissite default" do
  only_if { enabled?("000-default") }
  notifies :reload, "service[#{apache}]"
  action :run
end

directory("/var/www/") do
  owner "www-data"
  group "www-data"
  action :create
end