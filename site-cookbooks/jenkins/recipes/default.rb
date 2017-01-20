#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# apt_repository "jenkins" do
#     uri "https://pkg.jenkins.io/debian binary/"
#     key "https://pkg.jenkins.io/debian/jenkins.io.key"
#     retries 10
#     retry_delay 10
#     action :add
# end

bash 'jenkins' do
  code <<-EOH
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
  EOH
end

# add-apt-repositoryを利用できるようにする
package 'software-properties-common' do
  action :install
end

# open-jdk8のレポジトリを追加
bash 'add-apt-repository' do
  code <<-EOH
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update
  EOH
end

# open-jdk8をインストール
package "openjdk-8-jdk" do
  action :install
end

package "jenkins" do
    action :install
end

service "jenkins" do
    action [:enable, :start]
end
