require_relative "../spec_helper.rb"

describe "chef-awesome-appliance-repair::default" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs apache2" do
    expect(chef_run).to install_package "apache2"
  end 

  
end
