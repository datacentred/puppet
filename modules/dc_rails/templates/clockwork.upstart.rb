start on runlevel [2345]
stop on runlevel [!2345]

setuid rails
setgid rails

chdir <%= @app_home %>

exec <%= @home %>/.rbenv/shims/bundle exec clockwork <%= @home %>/clock.rb
