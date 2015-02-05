include_recipe "apt::default"

package "apache2" do
  action :install
end

cookbook_file "/etc/apache2/sites-enabled/AAR-apache.conf" do
 action :create
end

package "mysql-server" do
 action :install
end

package "mysql-client" do
 action :install
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

directory("/var/www/") do
 owner "www-data"
 group "www-data"
 action :create
end

directory "/var/www/AAR" do
 owner "www-data"
 group "www-data"
 action :create
end
