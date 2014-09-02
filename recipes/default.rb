#
# Cookbook Name:: ssh_banner
# Recipe:: default
#
# Copyright (C) 2014 Eugenio Marzo
#
# All rights reserved - Do Not Redistribute
#


_banner_file = "#{node['ssh_banner']['sshd_banner_dir']}/#{node['ssh_banner']['sshd_banner_file']}"

service "sshd" do
	  supports :status => true, :restart => true, :reload => true
end

cookbook_file "chef_ssh_banner" do
  path  _banner_file
  mode  0755
  owner "root"
  action :create
end


ssh_banner_banner  "banner" do    
  banner_file _banner_file
  sshd_config_file  node['ssh_banner']['sshd_config_file']
  paranoic_mode false
  action :delete
  notifies :restart, "service[sshd]"
end

