#
# Cookbook Name:: gerrit
# Recipe:: install
#
# Copyright 2013, Thinking Phone Networks, Inc.
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

# create user and group for gerrit
group node['gerrit']['username'] do
  action :create
end

user node['gerrit']['username'] do
  comment "Gerrit Code Review User"
  gid node['gerrit']['username']
  home node['gerrit']['home_dir']
  action :create
end

# install and configure the Gerrit database locally
if node['gerrit']['database']['type'] == "MYSQL"
  include_recipe "gerrit::database"
end

# configure gerrit
template "/etc/default/gerritcodereview" do
  source "gerritcodereview.erb"
  mode 00644
  owner node['gerrit']['username']
  group node['gerrit']['username']
  variables ({ :gerrit_site => "#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}" })
  notifies :restart, "service[gerrit]", :delayed
end

# create initial directory structure
# -- we don't use a recursive single resource call here because the base_dir ends
# -- up being root.root owner/group, so we need a minimum of at least two directory
# -- resource calls regardless.
directory "#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}" do
  owner node['gerrit']['username']
  group node['gerrit']['username']
  mode 00775
  action :create
end

directory "#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}/etc" do
  owner node['gerrit']['username']
  group node['gerrit']['username']
  mode 00775
  action :create
end

# build out gerrit configuration
template "#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}/etc/gerrit.config" do
  source "gerrit.config.erb"
  mode 00644
  owner node['gerrit']['username']
  group node['gerrit']['username']
  notifies :restart, "service[gerrit]", :delayed
end

# download the gerrit.war file if it doesn't already exist
remote_file "#{node['gerrit']['home_dir']}/gerrit.war" do
  owner node['gerrit']['username']
  group node['gerrit']['username']
  source "http://gerrit.googlecode.com/files/gerrit-full-#{node['gerrit']['version']}.war"
  not_if { File.exists?("#{node['gerrit']['home_dir']}/gerrit.war") }
end

# setup installation resource to be notified via remote_file resource
execute "Initialize Gerrit Site" do
  command "java -jar gerrit.war init -d #{node['gerrit']['base_dir']}"
  cwd node['gerrit']['home_dir']
  user node['gerrit']['username']
  group node['gerrit']['username']
  not_if { File.exists?("#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}/bin") }
end

# install the init.d script
link "/etc/init.d/gerrit" do
  to "#{node['gerrit']['home_dir']}/#{node['gerrit']['base_dir']}/bin/gerrit.sh"
end

# activate service
service "gerrit" do
  action [ :enable, :start ]
  supports :start => true, :stop => true
  status_command "/etc/init.d/gerrit check"
end
