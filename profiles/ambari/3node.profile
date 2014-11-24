{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ ],
  "nodes": [ 
    { "hostname": "gw",  "ip": "240.0.0.10", "roles": [ "ambari-server", "ambari-agent" ] },
    { "hostname": "nn",  "ip": "240.0.0.11", "roles": [ "ambari-agent" ] },
    { "hostname": "dn1",  "ip": "240.0.0.12", "roles": [ "ambari-agent" ] }
  ]
}
