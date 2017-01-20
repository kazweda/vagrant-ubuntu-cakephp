# -*- coding: utf-8 -*-
# nginxのドキュメントルート
default['nginx']['docroot']['owner'] = 'root'
default['nginx']['docroot']['group'] = 'root'
default['nginx']['docroot']['path'] = "/usr/share/nginx/html"
default['nginx']['docroot']['force_create'] = false
default['nginx']['default']['fastcgi_params'] = []
# nginxでテスト用のVirtualHostを使うか
default['nginx']['test']['available'] = false
default['nginx']['test']['fastcgi_params'] = []
# mysqlのrootパスワード
default['mysql']['root_password'] = 'password'
