{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "proxy_vm_mem": 1024,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ ],
  "nodes": [ 
    { "hostname": "proxy", "ip": "240.0.0.2", "roles": [ "proxy-server" ] },
    { "hostname": "gw",  "ip": "240.0.0.10", "roles": [ "proxy-client", "ambari-server", "ambari-agent" ] },
    { "hostname": "nn",  "ip": "240.0.0.11", "roles": [ "proxy-client", "ambari-agent" ] },
    { "hostname": "dn1",  "ip": "240.0.0.12", "roles": [ "proxy-client", "ambari-agent" ] }
  ]
}
