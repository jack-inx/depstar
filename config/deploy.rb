
# settings application name
set :application, "Depstar_Phase_3"
set :repository,  "git@github.com:jack-inx/TestingCapistrano.git"
set :branch, "master"
set :deploy_to, "/home/depstar/rails_apps/#{application}"
set :domain, "depstar.com"

set :scm, :git                               # You can set :scm explicitly or Capistrano will make an intelligent guess 
                                             # based on known version control directory names 
set :stages, %w(production)
set :default_stage, "production" # "production"
require 'capistrano/ext/multistage'     

#############################################################
# Bundler
#############################################################

require 'bundler/capistrano'

set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,    "--deployment --quiet"
set :bundle_without,  [:development, :test]
set :bundle_cmd,      "bundle" # e.g. "/opt/ruby/bin/bundle"
set :bundle_roles,    {:except => {:no_release => true}} # e.g. [:app, :batch]


#############################################################
# RVM
#############################################################

#require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3-p194@global'
set :rvm_type, :system



                                            # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

default_run_options[:pty] = true             # Must be set for the password prompt
ssh_options[:forward_agent] = true           # from git to work
                                  
set :user, "depstar"
set :password, "C#l#mb@~" 
set :use_sudo, false                       # The server's user for deploys
#set :scm_passphrase, "p@ssw0rd"            # The deploy user's password
set :deploy_via, :remote_cache


role :web, domain
role :app, domain                           # This may be the same as your `Web` server
role :db,  domain, :primary => true         # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart do#, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end


