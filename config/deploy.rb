require 'bundler/capistrano'
set :user, 'christopher'
set :domain, 'cgthornt.com'

set :scm, :subversion
set :repository,  "https://svn.cgthornt.com/fiddlevent/trunk/"
set :scm_verbose, true

set :applicationdir, "/home/christopher/fiddlevent"
set :application, "Fiddlevent"

set :scm_username, "christopher" 
set :scm_password, Proc.new { Capistrano::CLI.password_prompt("SVN password for #{scm_username}, please: ") } 

role :web, "cgthornt.com"
role :app, "cgthornt.com"
role :db,  "cgthornt.com", :primary => true 

set :deploy_to, applicationdir
set :deploy_via, :copy
set :copy_strategy, :export

after "deploy:update_code", "deploy:migrate"
after "deploy:update_code", "deploy:load_from_remote"

default_run_options[:pty] = true



# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :load_from_remote do
    run "cd #{current_path} && bundle exec rake fiddle:load_from_remote RAILS_ENV=production"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end