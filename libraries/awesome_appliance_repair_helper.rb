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

  module GeneralCommands
    include Chef::Mixin::ShellOut

    def application_exists?
      command = shell_out("[ -d /var/www/AAR ] && echo \"exists\" || echo \"does not exist\"", returns: [0, 2])

      command.stdout=~/exists/ and command.stderr.empty?
    end
  end

  module ApacheCommands
    include Chef::Mixin::ShellOut

    def enabled?(name)
      command = shell_out("[ -L /etc/apache2/sites-enabled/#{name} ] && echo \"exists\" || echo \"does not exist\"", returns: [0, 2])

      command.stdout=~/exists/ and command.stderr.empty?
    end
  end
end
