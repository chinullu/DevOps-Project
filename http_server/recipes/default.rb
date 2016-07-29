#
# Cookbook Name:: http_server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#Install httpd server if missing...
package "httpd" do
	action [:install]
end

#Install https support is missing
package "mod_ssl" do
	action [:install]
end

#Create ssl directory in apache http directory, so that http can be enabled.
directory "/etc/httpd/ssl" do
        action :create
        recursive true
        mode 0755
end

#Put the ssl certificate in ssl directory
template "/etc/httpd/ssl/ca.crt" do
  source 'ca.crt.erb'
  mode 0644
end

#Put the ssl certificate key in ssl directory
template "/etc/httpd/ssl/ca.key" do
	source 'ca.key.erb'
	mode 0644
end
#Copy ssl conf. SSL conf will enable the https support
template "/etc/httpd/ssl/ssl.conf" do
	source "ssl.conf.erb"
	mode 0644
end

template "/etc/httpd/conf/httpd.conf" do
	source "httpd.conf.erb"
end
#Secure the certificate with SE linux
execute "change_for_selinux" do
        command "chcon -Rv --type=httpd_sys_content_t /etc/httpd/ssl/"
        action :run
end

#Block all linux ports. So that only port 22,80 and 443 are accessible. Ping is also disabled to stop DOS
execute "block_all_ports" do
        command "iptables -P INPUT DROP"
        action :run
end

execute "disable_all_ports_forward" do
        command "iptables -P FORWARD DROP"
        action :run
end

execute "all_inside_to_go_outsite" do
        command "iptables -P OUTPUT ACCEPT"
        action :run
end

execute "allow_port_80" do
        command "iptables -A INPUT -p tcp --dport 80 -j ACCEPT"
        action :run
end

execute "all_port_443" do
        command "iptables -A INPUT -p tcp --dport 443 -j ACCEPT"
        action :run
end

execute "all_port_ssh" do
        command "iptables -A INPUT -p tcp --dport 22 -j ACCEPT"
        action :run
end



service "httpd" do
  action [:enable, :restart]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
