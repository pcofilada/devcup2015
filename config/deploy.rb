# config valid only for Capistrano 3.1
lock '3.4.0'

set :user,            'deployer'
set :repo_url,        'git@github.com:pcofilada/devcup2015.git'
set :application,     'devcup2015'
set :puma_threads,    [1, 4]
set :puma_workers,    2

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        true
set :asset_roles,     [:web, :app]
set :deploy_via,      :remote_cache
set :deploy_to,       ->{ "/home/#{fetch(:user)}/apps/#{fetch(:application)}" }
set :puma_conf,       "#{shared_path}/puma.rb"
set :puma_bind,       ->{"unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"}
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     ->{ {:forward_agent => true, :user => fetch(:user), :keys => %w(~/.ssh/id_rsa.pub)} }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to true if using ActiveRecord
set :bundle_binstubs, nil

# Linked Files & Directories (Default None):
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
# linked_dirs = Set.new(fetch(:linked_dirs, [])) # https://github.com/capistrano/rails/issues/52
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# set :linked_dirs, linked_dirs.to_a

# capistrano-db-tasks
set :db_local_clean, true
set :db_remote_clean, true
set :locals_rails_env, 'production'
set :assets_dir, 'public/system'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      within current_path do
        execute :rake, "paperclip:refresh:missing_styles", "RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end
  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
