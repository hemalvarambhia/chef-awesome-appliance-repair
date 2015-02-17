include_recipe "apt::default"

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

template "/var/www/AAR/AAR_config.py" do
  variables aar_db_password: node[:aar_db_password], secret_key: node[:aar_secret_key]
  action :create
end
