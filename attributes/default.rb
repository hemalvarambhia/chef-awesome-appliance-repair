default[:aar_db_password] = "aar_db_password"
default[:aar_secret_key] = "secret_key"

default[:apache][:package] = case node[:platform]
                               when "ubuntu"
                                 "apache2"
                               when "centos"
                                 "httpd"
                             end

default[:apache][:service] = case node[:platform]
                               when "ubuntu"
                                 "apache2"
                               when "centos"
                                 "httpd"
                             end

default[:apache][:dir] = case node[:platform]
                           when "ubuntu"
                             "/etc/apache2"
                           when "centos"
                             "/etc/httpd"
                         end

default[:apache][:conf_dir] = case node[:platform]
                                when "ubuntu"
                                  "#{node[:apache][:dir]}/sites-enabled"
                                when "centos"
                                  "#{node[:apache][:dir]}/conf.d"
                              end