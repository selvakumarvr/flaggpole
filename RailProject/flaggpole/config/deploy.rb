##### Application #####
set :application, "flaggpole"
#set deploy_to: "/web/rails/#{application}" # default /u/apps/

##### Settings #####
default_run_options[:pty] = true
#set :use_sudo, true
#ssh_options[:forward_agent] = true

##### Servers #####
set :user, "deploy"
role :web, "dev.flaggpole.com"                    # Your HTTP server, Apache/etc
role :app, "dev.flaggpole.com"                    # This may be the same as your `Web` server
role :db,  "dev.flaggpole.com", :primary => true  # This is where Rails migrations will run
#role :db,  "your slave db-server here"

##### Git #####
# http://github.com/guides/deploying-with-capistrano
set :repository,  "git@bitbucket.org:twitzip/flaggpole.git"
set :scm, :git
#set :scm_passphrase, "p@ssw0rd"
set :branch, "master"
#set :deploy_via, :remote_cache
#set :git_shallow_clone, 1

##### Passenger #####
namespace :deploy do
#  task :start {}
#  task :stop {}
  desc "Restart mod_passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_passenger"
    task t, :roles => :app do ; end
  end
end

##### Permissions #####
desc "Change group to www-data"
task 'chown_to_www-data', :roles => [ :app, :db, :web ] do
  sudo "chown -R #{user}:apache #{deploy_to}"
end

desc "Fix file permissions"
task :fix_file_permissions, :roles => [ :app, :db, :web ] do
  sudo "chmod -R g+rw #{current_path}/tmp"
  sudo "chmod -R g+rw #{current_path}/log"
  sudo "chmod -R g+rw #{current_path}/public/system"
end

##### Crontab #####
after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
