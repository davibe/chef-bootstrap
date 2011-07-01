Chef Bootstrapping Scripts
==========================

Some simple scripts to get started using [Chef](http://wiki.opscode.com/display/chef/Home).

Bootstrapping a server on AWS EC2
---------------------------------

Use the `chef-server/chef-server.init` script as user data when starting an AWS EC2 instance, to bootstrap a
chef server.

The script will perform the steps described in
[Package Installation on Debian and Ubuntu](http://wiki.opscode.com/display/chef/Package+Installation+on+Debian+and+Ubuntu)
and should therefore be used with an Ubuntu AMI with a recent version of the `cloud-init` package. For more
information on `cloud-init' see its [Documentation](https://help.ubuntu.com/community/CloudInit).

Also, a hostname alias for `127.0.0.1` named "chef" will be created, and the chef server URL will be
`http://chef:4000/`. When you bootstrap clients, they should create an alias in `/etc/hosts` to map the IP address
of the chef server instance to the hostname "chef".

Lastly, the `chef-server-create-admin.sh` script will be downloaded and executed to create
an admin "client" on the chef server as described in
[Configure the Command Line Client](http://wiki.opscode.com/display/chef/Package+Installation+on+Debian+and+Ubuntu#PackageInstallationonDebianandUbuntu-ConfiguretheCommandLineClient).

After the installation, the chef server web UI will run on port 4040, with an administrative user "admin" and a
password "chef".

