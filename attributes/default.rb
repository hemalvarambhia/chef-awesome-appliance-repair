default[:aar_db_password] = "aar_db_password"
default[:aar_secret_key] = "secret_key"

case node[:platform]
  when "ubuntu"
    default[:apache][:package] = "apache2"
    default[:apache][:service] = "apache2"
    default[:apache][:dir] = "/etc/apache2"
    default[:apache][:conf_dir] = "#{node[:apache][:dir]}/sites-enabled"
    default[:mysql][:daemon] = "mysql"
    default[:mysql][:client] = "mysql-client"
  when "centos"
    default[:apache][:package] = "httpd"
    default[:apache][:service] = "httpd"
    default[:apache][:dir] = "/etc/httpd"
    default[:apache][:conf_dir] = "#{node[:apache][:dir]}/conf.d"
    default[:mysql][:daemon] = "mysqld"
    default[:mysql][:client] = "mysql"
end