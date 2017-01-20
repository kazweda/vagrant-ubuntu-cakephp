# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 配列で列挙しているパッケージをインストール
%w{curl php7.0 php7.0-cli php7.0-fpm php7.0-mysql php-pear
    php7.0-curl php7.0-xsl php7.0-mcrypt
    mysql-server-5.7 nginx git}.each do |p|
    package p do
        action :install
    end
end

# mcrypt モジュールを有効にする
execute "phpenmod mcrypt" do
    action :run
end

# apacheがインストール済みの場合は停止して無効化する
service "apache2" do
    action [:disable, :stop]
    only_if "dpkg -l | grep apache2"
end

# nginx用の設定ファイルをテンプレートから作成する
template "/etc/nginx/sites-available/test" do
    source "test.erb"
    owner "root"
    group "root"
    mode 0644
    action :create
    only_if { node['nginx']['test']['available'] == true }
end

# シンボリックリンクを張って設定ファイルを有効化する
link "/etc/nginx/sites-enabled/test" do
    to "/etc/nginx/sites-available/test"
    only_if {node['nginx']['test']['available'] == true }
end

# デフォルトのサイト設定を上書きする
template "/etc/nginx/sites-available/default" do
    source "default.erb"
    owner "root"
    group "root"
    mode 0644
    action :create
end

# nginxのドキュメントルートを作成する
directory node['nginx']['docroot']['path'] do
    owner node['nginx']['docroot']['owner']
    group node['nginx']['docroot']['group']
    mode 0755
    action :create
    recursive true
    only_if { not File.exists?(node['nginx']['docroot']['path']) and
        node['nginx']['docroot']['force_create']}
end

# ダミーのphpスクリプトを作成する
template "#{node['nginx']['docroot']['path']}/index.php" do
    source "index.php.erb"
    owner node['nginx']['docroot']['owner']
    group node['nginx']['docroot']['group']
    mode 0644
    action :create
    only_if { not File.exists?("#{node['nginx']['docroot']['path']}/index.php") and
        node['nginx']['docroot']['force_create']}
end

# nginxのサービスを有効化して起動する
service "nginx" do
    action [:enable, :restart]
end

# mysqlのrootアカウントのパスワードをセットする
execute "set_mysql_root_password" do
    command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['root_password']}\""
    action :run
    only_if "/usr/bin/mysql -u root -e 'show databases:'"
end
