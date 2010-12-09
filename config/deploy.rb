set :application, "production"
set :deploy_to, "/home/depstar/rails_apps/#{application}"


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
# Servers
#############################################################

set :user, "depstar"
set :domain, "depstar.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
# Subversion
#############################################################

set :repository,  "https://subversion.assembla.com/svn/sparkwire/Depstar/trunk"
set :checkout, "export"

set :scm, :subversion

role :web, "depstar.com"                          # Your HTTP server, Apache/etc
role :app, "depstar.com"                          # This may be the same as your `Web` server
role :db,  "depstar.com", :primary => true        # This is where Rails migrations will run

set :scm_command, "/usr/bin/svn"
set :local_scm_command, "svn"
set :use_sudo, false

#############################################################
# Passenger
#############################################################

deploy.task :restart, :roles => :app do
  
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end
  
end