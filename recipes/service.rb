#
# Cookbook Name:: dnsmasq
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

user "dnsmasq" do
  system true
  shell "/bin/false"
end

cmd = [ "--bind-interfaces" ]

if node['dnsmasq']['listen-addresss']
  node['dnsmasq']['listen-addresss'].each do | address |
    cmd << "--listen-address=#{address}"
  end
end

if node['recipes'].include?('dnsmasq::dns')
  cmd << "--no-resolv"
  cmd << "--no-poll"
  cmd << "--cache-size=0"
  if node['dnsmasq']['servers']
    node['dnsmasq']['servers'].each do | server |
      cmd << "--server=#{server}"
    end
  end
end
if node['recipes'].include?('dnsmasq::dhcp')
#  cmd << ""
end

template "upstart" do
  source "upstart.erb"
  path "/etc/init/dnsmasq-chef.conf"
  mode 0440
  owner "root"
  group "root"
  variables(
    :cmd => cmd
  )
  notifies :stop, "service[dnsmasq-chef]"
  notifies :start, "service[dnsmasq-chef]"
end

service "dnsmasq-chef" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :reload => true
  action :start
end
