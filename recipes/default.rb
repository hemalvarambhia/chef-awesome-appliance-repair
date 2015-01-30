include_recipe "apt::default"

package "apache2" do
  action :install
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
