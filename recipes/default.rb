#
# Cookbook Name:: praxis_fog_gateway_cookbook
# Recipe:: default
#
# Copyright (C) 2014 RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'json'
praxis_dir='/opt/praxis-fog-gateway'
node.default['rvm']['default_ruby'] = "2.1.5"
node.default['rvm']['user_default_ruby'] = "2.1.5"
include_recipe "rvm::system"
include_recipe "rvm::gem_package"
include_recipe "bluepill::default"

gem "unicorn" do
  action :install
end

gem "bundler" do
  action :install
end

git praxis_dir do
  repository 'git://github.com/rshade/praxis-fog-gateway.git'
  revision node['praxis_fog_gateway_cookbook']['git_revision']
  action :sync
end

bash "bundle install" do
  cwd praxis_dir
  code <<-EOF
    bundle install
  EOF
end

template "#{praxis_dir}/config/.fog.yml" do
  source "fog.yml.erb"
  owner "root"
  group "root"
  mode "0600"
  variables({
    :creds => JSON.parse(node['praxis_fog_gateway_cookbook']['fog_creds'])
  })
  action :create
end

directory "#{praxis_dir}/logs" do
  owner "root"
  group "root"
  owner "0755"
  recursive true
  action :create
end

directory "#{praxis_dir}/tmp/pids" do
  owner "root"
  group "root"
  owner "0755"
  recursive true
  action :create
end

template '/etc/bluepill/praxis-fog-gateway.pill' do
    source 'praxis-fog-gateway.pill.erb'
end

bluepill_service 'praxis-fog-gateway' do
  action [:enable, :load, :start]
end
