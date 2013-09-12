#
# Cookbook Name:: postgresql
# Recipe:: server
#

include_recipe "postgresql"

# don't auto-start the service to allow custom configuration
#dpkg_autostart "postgresql" do
#  allow false
#end

file "/usr/sbin/policy-rc.d" do
  mode 0755
  owner "root"
  group "root"
  content "#!/bin/sh\nexit 101"
  not_if "dpkg -s postgresql-#{node["postgresql"]["version"]}"
end

# install the package
package "postgresql-#{node["postgresql"]["version"]}"

file "/usr/sbin/policy-rc.d" do
  action :delete
  only_if "dpkg -s postgresql-#{node["postgresql"]["version"]}"
end

# setup the data directory
include_recipe "postgresql::data_directory"

# add the configuration
include_recipe "postgresql::configuration"

# declare the system service
include_recipe "postgresql::service"

# setup users
include_recipe "postgresql::pg_user"

# setup databases
include_recipe "postgresql::pg_database"



