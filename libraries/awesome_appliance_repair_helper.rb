module ChefAwesomeApplianceRepairHelper
  module MySQLCommands
    include Chef::Mixin::ShellOut

    def database_exists?
      command = shell_out("mysql -u root -e \"SHOW DATABASES LIKE 'AARdb'\"", returns: [0, 2])
      expected_database = Regexp.escape "AARdb"

      command.stdout=~/#{expected_database}/ and command.stderr.empty?
    end

    def user_exists?
      command = shell_out("mysql -u root -e \"SELECT User FROM mysql.user where user='aarapp'\"", returns: [0, 2])
      expected_user = "aarapp"

      command.stdout=~/#{expected_user}/ and command.stderr.empty?
    end
  end
end