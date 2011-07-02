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

    # download the cloud-init file to be used as instance user data
    $ ubuntu@ubuntu11-vm:~$ wget -O chef-server.init https://raw.github.com/CoreMedia/chef-bootstrap/master/chef-server/chef-server.init

    # start up a new instance using chef-server.init as the user data file
    $ ec2-run-instances ami-359ea941 --instance-type m1.small --region ${EC2_REGION} --key ${EC2_KEYPAIR} --user-data-file chef-server.init

    # find the public host name of your new instance
    $ ec2-describe-instances --region {EC2_REGION}

    # log in to your new instance (this assumes the security group allows inbound traffic on port 22)
    # chef-server port 4000 and chef-server-webui port 4040 will be forwarded from your local ports 4000 and 4040
    $ ssh -i ${EC2_SSH_KEY} -L 4000:chef:4000 -L 4040:chef:4040 ec2-46-137-66-25.eu-west-1.compute.amazonaws.com

The `cloud-init` is redirected to `/var/log/cloud-init.log`.

### Compatibility

The script has been tested with the
[Ubuntu 11.04 (natty) release AMI](http://uec-images.ubuntu.com/server/releases/natty/release/) `ami-359ea941`
and `chef 0.10.0-1`.

### Known Issues

#### chef-server-webui fails to start automatically

The installation script of the `chef-server` package attempts to start the `chef-server` and `chef-server-webui` sevices.
Apparently, there is a problem with starting the `chef-server-webui` service, because it often fails. In this
case there will be no log file `/var/log/chef/server-webui.log`.

As a workaround:

- make sure the `chef-server-webui` service is stopped: `sudo /etc/init.d/chef-server-webui stop`
- start the web UI process manually (it will log to the console, not the log file): `sudo /usr/sbin/chef-server-webui`
- when the process is up ("Successfully bound to port 4040"), stop it with `Ctrl-C`
- start the `chef-server-webui` service: `sudo /etc/init.d/chef-server-webui start`

The service should start now and log to `less /var/log/chef/server-webui.log`.

### chef-server-webui does not use the configured default admin password

It happens that the web UI does not use admin password configured in the `cloud-init` script ("chef", this will be
written to `/etc/chef/webui.rb`), but the default "p@ssw0rd1". If you cannot login as admin/chef, try admin/p@ssw0rd1.

### "Tampered with cookie" message when opening the chef web UI

The chef web UI signs its cookies. When you create a completely new chef installation (e.g. by using this script), it
will create a new session signing key. If you have visited a previous chef installation under the same URL
(http://chef:4040/) before, your browser might still have cookies signed with the old key, which will lead to this message.
As a workaround, delete those cookies from your browser cache.
