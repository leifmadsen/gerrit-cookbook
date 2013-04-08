#
# Cookbook Name:: gerrit
# Recipe:: database
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

include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "database"

# install mysql gem
gem_package "mysql" do
  action :install
end

# make sure shadow is available immediately
ruby_block "require mysql library" do
  block do
    Gem.clear_paths  # <-- Necessary to ensure that the new library is found
    require 'mysql' # <-- gem is 'ruby-shadow', but library is 'shadow'
  end
end

service "mysqld" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable, :start ]
end

mysql_connection_info = { :host => "localhost",
                          :username => 'root',
                          :password => node['mysql']['server_root_password']
                        }

# create gerrit database user
mysql_database_user node['gerrit']['username'] do
  connection mysql_connection_info
  host '%'
  password node['gerrit']['db_password']
  action :create
end

# create gerrit review database
mysql_database node['gerrit']['database']['database'] do
  connection mysql_connection_info
  action :create
end

# update charset for gerrit database
mysql_database "Change charset of #{node['gerrit']['database']['database']}" do
  connection mysql_connection_info
  action :query
  sql "ALTER DATABASE #{node['gerrit']['database']['database']} charset=latin1"
end

# grant permissions to the gerrit database user on the gerrit review database
mysql_database_user node['gerrit']['username'] do
  connection mysql_connection_info
  host '%'
  password node['gerrit']['db_password']
  database_name node['gerrit']['database']['database']
  action :grant
end

# flush privs
mysql_database "flush the privileges" do
  connection mysql_connection_info
  sql "flush privileges"
  action :query
end
