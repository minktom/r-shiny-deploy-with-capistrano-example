lock '3.4.0'

set :application, 'hello-r'
set :repo_url, 'git@github.com:minktom/r-shiny-deploy-with-capistrano-example.git'

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "install R packages"
  task :install_R_packages do
    r_packages = File.read("#{release_path}/R_packages.txt").lines.map &:strip
   
    r_package_cmds = r_packages.map do |package|
      'if(!require(\\\"#{package}\\\")){ install.packages(\\\"#{package}\\\",lib=c(\\\"#{shared_path}/R\\\"), repos=\\\"http://cran.cnr.
  berkeley.edu/\\\"); };'
    end

    command = r_package_cmds.join(' ')
   
    sudo "sh -c 'if [ ! -d #{shared_path}/R ]; then mkdir #{shared_path}/R; fi'"
    sudo "sh -c 'export R_LIBS_USER=#{shared_path}/R && R --vanilla -e \"#{command}\"'"
  end
  #after :update_code, :install_R_packages
end
