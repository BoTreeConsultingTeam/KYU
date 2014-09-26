require "bundler/capistrano"
require "rvm/capistrano"

server "104.131.111.55", :web, :app, :db, primary: true

set :application, "kyu"
set :user, "root"
set :port, 1980
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:BoTreeConsultingTeam/KYU.git"
set :branch, "development_phase_1_pull_requests"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "deploy:migrate"

namespace :deploy do
  # Reference: https://www.ruby-forum.com/topic/85305
  task :symlink_assets, :roles => [:app, :db, :web] do
    run "ln -nfs #{shared_path}/assets #{deploy_to}/assets"
  end
  after "deploy", "deploy:symlink_assets"

  # Reference: http://stackoverflow.com/a/11462003/936494
  task :cold do
    transaction do
      update
      setup_db  #replacing migrate in original
      start
    end
  end

  task :setup_db, :roles => :app do
    raise RuntimeError.new('db:setup aborted!') unless Capistrano::CLI.ui.ask("About to `rake db:setup`. Are you sure to wipe the entire database (anything other than 'yes' aborts):") == 'yes'
    run "cd #{current_path}; bundle exec rake db:setup RAILS_ENV=#{rails_env}"
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  after "deploy", "deploy:asset:generate_assets"
end