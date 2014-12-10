HDP-Builder
===========
My fork of **[Hortonworks/structor](https://github.com/hortonworks/structor)**, a set of Vagrant scripts behind a shell script interface for provisioning multi-node HDP clusters using Ambari Blueprints. An optional Squid cache is available for faster multi-node provisioning.

The only supported OS at this time is CentOS 6 with VirtualBox provider.

## Dependencies
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagarant](https://docs.vagrantup.com/v2/installation/)

## Modify the cluster
Structor supports profiles that control the configuration of the
virtual cluster.  Various built-in profiles are supplied, and new profile submissions are encouraged. A profile consists of 5 files:
- structor profile (ex: 3node-min.profile)
- Ambari hostmap (ex: 3node-min.hostmap)
- Ambari blueprint (ex: hdp-2.2.0/3node-min.blueprint)
- Ambari repo (ex: ambari-1.7.0/ambari.repo)
- HDP repo (ex: hdp-2.2.0/hdp.repo)

## Verified combinations
The following combinations are tested and verified to result in a working cluster.

| HDP | 3node-min | 3node-full | 1node-min | 1node-full |
|---|---|---|---|---|
| 2.2.0 | YES | ? | ? | ? |
| 2.1.2 | ? | ? | ? | ? |
| 2.0.6 | YES | ? | ? | ? |

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

## Bring up the cluster

Use `./ambari-cluster <hdp-version> <ambari-version> [profile-name]` to bring up the cluster. This will take 20 to 40 minutes for
a 3 node cluster depending on your hardware and network connection.

Use `vagrant ssh gw` to login to the gateway machine. If you configured
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

# TODO
- Vagrant Docker provider
- Enable security

----
# Everything below is untested in my fork

### Set up Kerberos

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
