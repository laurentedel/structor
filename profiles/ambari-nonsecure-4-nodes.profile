{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ ],
  "nodes": [ 
    { "hostname": "ambari",  "ip": "240.0.0.10", "roles": [ "ambari-server" ] },
    { "hostname": "master",  "ip": "240.0.0.11", "roles": [ "ambari-agent" ] },
    { "hostname": "slave1",  "ip": "240.0.0.12", "roles": [ "ambari-agent" ] },
    { "hostname": "slave2",  "ip": "240.0.0.13", "roles": [ "ambari-agent" ] }
  ]
}
