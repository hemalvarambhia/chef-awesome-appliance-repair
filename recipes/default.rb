include_recipe "apt::default"

package "apache2" do
  action :install
end