#
# Cookbook Name:: duckduckhack-vm
# Recipe:: InitialDiskCleanup
#

# 6.8 MB when installed. This merely got pulled in because of a "recommends"
package "geoip-database" do
  action :purge
end

# combined 1.2 MB when installed. Obviously not needed on the DuckDuckHack VM
package "landscape-client" do
  action :purge
end
package "landscape-common" do
  action :purge
end

# 2.9 MB when installed. Also not needed on the DuckDuckHack VM
package "juju" do
  action :purge
end

# Remove 11.5 MB (installed size) worth of landscape and juju dependencies
execute 'sudo apt-get -y autoremove'

# 5.7 MB when installed. Pulled in for juju/landscape, but kept because of a
# recommends rule
package "python-twisted-core" do
  action :purge
end
