default['dnsmasq']['install_method'] = "packages"
case node['platform']
when "ubuntu"
  default['dnsmasq']['launch_method'] = "upstart"
end

default['dnsmasq']['listen-addresss'] = nil
default['dnsmasq']['servers'] = nil
