module ChefAwesomeApplianceRepairHelper
  module MySQLCommands
    include Chef::Mixin::ShellOut

    def database_exists?
      command = shell_out("mysql -u root -e \"SHOW DATABASES LIKE 'AARdb'\"", returns: [0, 2])
      expected_database = Regexp.escape "AARdb"

      command.stdout=~/#{expected_database}/ and command.stderr.empty?
    end
  end
end
