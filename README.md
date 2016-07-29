# DevOps-Project

1. Created web server using a configuration management tool Chef with the following content:
<html>
   <head>
     <title>Hello World</title>
    </head>
    <body>
     <h1>Hello World!</h1>
    </body>
</html>

2. Secureed this application and host such that only appropriate ports are publicly exposed and any http requests are redirected to https are automated using chef.
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

3.Developed and applied automated tests to validate the correctness of the server configuration which is written in perl script in the file auto-test.pl, command to run this file: perl /path/file.pl


