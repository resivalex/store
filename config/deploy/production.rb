set :deploy_to, '/home/mb/store'

server '185.118.64.158', user: 'mb', roles: %w(app db web)
