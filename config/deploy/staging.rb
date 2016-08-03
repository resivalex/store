set :deploy_to, '/var/www/store'

server 'resivalex.com', user: 'deploy', roles: %w(app db web)
