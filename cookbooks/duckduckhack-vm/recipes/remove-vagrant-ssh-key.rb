#
# Cookbook Name:: duckduckhack-vm
# Recipe:: remove-vagrant-ssh-key

# Remove the "vagrant insecure public key", which would let arbitrary users SSH
# into the VM without knowing the password.
file "/home/vagrant/.ssh/authorized_keys" do
  action :delete
end
