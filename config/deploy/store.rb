set :deploy_to, '/home/mb/store'
set :repo_url, 'git@github.com:georgiy-voldaev/store.git'

server '185.118.64.158', user: 'mb', roles: %w{app db web}
