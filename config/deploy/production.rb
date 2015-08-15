set :stage,       :production
set :rails_env    :production
set :branch       'master'

server 'patrickofilada.cloudapp.net', :port => 22, :roles => [:web, :app, :db], :primary => true, :user => 'deployer'

set :ssh_options, {
  :user => fetch(:user)
}
