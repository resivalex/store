# Linux (from root)

## Add user
```
adduser userrr
usermod -a -G sudo userrr
apt-get update
apt-get install sudo
apt-get install git
```
## Locales

### Create file `/etc/default/locale`
```
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LC_TYPE=en_US.UTF-8
```
### Execute
```
locale-gen en_US.UTF-8
dpkg-reconfigure locales
```

### Relogin
`logout`

# Deployment

## PostgreSQL
```
sudo apt-get install postgresql
sudo apt-get install libpq-dev
pg_createcluster 9.3 main --start
```

### Login as postgres
```
sudo su - postgres
```

### Create user for PostgreSQL with same user name and user with password for app
```
createuser -s userrr
createuser -sP dbuser
logout
```

### Create DB
```
createdb store
```

## Image processor
```
sudo apt-get install imagemagick
```

## Install rvm and ruby
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
sudo apt-get install curl
\curl -sSL https://get.rvm.io | bash -s stable
```

### Relogin
```
logout
```

### Software for gems
```
rvm install ruby-2.3.1
gem install bundler
sudo apt-get install nodejs
```

## Copy secrets in capistrano shared folder (e.g. by `scp`)
```
mkdir -p ~/store/shared/config
```
### Copy this files `~/store/shared/config/(database.yml, secrets.yml)`

## Install web server

### Add keys
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
```

### Add our APT repository
```
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
```

### Install Passenger + Nginx
```
sudo apt-get install -y nginx-extras passenger
```

### Nginx settings

`/etc/nginx/nginx.conf`
- Uncomment this line
  `include /etc/nginx/passenger.conf;`

`/etc/nginx/site-available/your-domain.com`
```
charset utf-8;
server {
  listen 80;
  server_name your-domain.com localhost;
  root /home/userrr/store/current/public;

  keepalive_timeout 300;
  client_max_body_size 4G;

  passenger_ruby /home/userrr/.rvm/wrappers/ruby-2.3.1/ruby;

  passenger_enabled on;
  passenger_base_uri /;

  ...
}
```

- Restart Nginx `service nginx restart`

# Deploy from your PC
`cap production deploy`
