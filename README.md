# HDP-Builder
=======

My fork of **[Hortonworks/structor](https://github.com/hortonworks/structor).**


Vagrant files for creating virtual multi-node Hadoop clusters on various OSes,
using Ambari Blueprints. Optional Squid caching server for faster provisiong. I
hope to soon add support for the Vagrant Docker provider.

The currently supported OSes and the providers:
* centos 6 (virtualbox and vmware_fusion)

## Dependencies
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMware Fusion](http://www.vmware.com/products/fusion/)
* [Vagarant](https://docs.vagrantup.com/v2/installation/)

## Modify the cluster

Structor supports profiles that control the configuration of the
virtual cluster.  There are various profiles stored in the profiles
directory including a default.profile. To pick a different profile,
create a link in the top level directory named current.profile that
links to the desired profile.

Current profiles:
* hdp2.1-3node-min - HDFS, YARN, MR2, Zookeeper, Hive, Nagios, Ganglia
* hdp2.1-3node-full - HDFS, YARN, MR2, Zookeeper, Hive, Nagios, Ganglia, Storm, Oozie, HBase, Falcon, Sqoop
* hdp2.2-3node-min - HDFS, YARN, MR2, Zookeeper, Hive, Nagios, Ganglia (branch hdp-2.2)

You are encouraged to contribute new working profiles that can be
shared by others.

The types of control knob in the profile file are:
* nodes - a list of virtual machines to create
* security - a boolean for whether kerberos is enabled
* vm_memory - the amount of memory for each vm
* clients - a list of packages to install on client machines

For each host in nodes, you define the name, ip address, and the roles for 
that node. The available roles are:

* ambari-server - Ambari server
* ambari-client - member of Ambari cluster
* proxy-server - Squid proxy server for yum caching
* proxy-client Squid proxy client for yum caching
* client - client machine
* kdc - kerberos kdc
* nn - HDFS NameNode
* yarn - Yarn Resource Manager and MapReduce Job History Server
* slave - HDFS DataNode & Yarn NodeManager
* hive-db - Hive MetaStore backing mysql
* hive-meta - Hive MetaStore
* zk - Zookeeper Server

This is an example of the current default.profile
```
{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hdfs", "yarn", "pig", "hive", "zk" ],
  "nodes": [
    { "hostname": "proxy", "ip": "240.0.0.2", "roles": [ "proxy-server" ] },
    { "hostname": "gw", "ip": "240.0.0.10", "roles": [ "ambari-server", "ambari-client", "proxy-client" ] },
    { "hostname": "nn", "ip": "240.0.0.11", "roles": [ "ambari-client", "proxy-client" ] },
    { "hostname": "dn1", "ip": "240.0.0.12", "roles": [ "ambari-client", "proxy-client" ] }
  ]
}
```

## Bring up the cluster

Use `./ambari-cluster <profile-name>` to bring up the cluster. This will take 30 to 40 minutes for 
a 3 node cluster depending on your hardware and network connection.

Use `vagrant ssh gw`` to login to the gateway machine. If you configured 
security, you'll need to kinit before you run any hadoop commands.

## Set up on Mac
 
### Add host names

in /etc/hosts:
```
240.0.0.2 proxy.example.com
240.0.0.10 gw.example.com
240.0.0.11 nn.example.com
240.0.0.12 slave1.example.com
240.0.0.13 slave2.example.com
240.0.0.14 slave3.example.com
```

### Finding the Web UIs

| Server      | Non-Secure                   | Secure                        |
|:-----------:|:----------------------------:|:-----------------------------:|
| NameNode    | http://nn.example.com:50070/ | https://nn.example.com:50470/ |
| ResourceMgr | http://nn.example.com:8088/  | https://nn.example.com:8090/  |
| JobHistory  | http://nn.example.com:19888/ | https://nn.example.com:19890/ |
 
### Set up Kerberos (for security - **untested for Ambari clusters**)

in /etc/krb5.conf:
```
[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  default_realm = EXAMPLE.COM
  dns_lookup_realm = false
  dns_lookup_kdc = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  udp_preference_limit = 1

[realms]
  EXAMPLE.COM = {
    kdc = nn.example.com
    admin_server = nn.example.com
  }

[domain_realm]
  .example.com = EXAMPLE.COM
  example.com = EXAMPLE.COM
```

You should be able to kinit to your new domain (user: vagrant and 
password: vagrant):

```
% kinit vagrant@EXAMPLE.COM
```

### Set up browser (for security)

Do a `/usr/bin/kinit vagrant` in a terminal. I've found that the browsers
won't use the credentials from MacPorts' kinit. 

Safari should just work.

Firefox go to "about:config" and set "network.negotiate-auth.trusted-uris" to 
".example.com".

Chrome needs command line parameters on every start and is not recommended.
