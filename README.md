## Steps

A simple mongodb cluster with 1 config server, 2 shard servers and 1 router.

```bash
openssl rand -base64 741 > ./data/replica-keyfile
chmod 600 ./data/replica-keyfile
```

```javascript
// on mongodb-config
rs.initiate({
  _id: "config_rs",
  configsvr: true,
  members: [
    { _id : 0, host : "192.168.1.38:30101" },
  ]
})
```

```javascript
// on mongodb-shard-1
rs.initiate({
  _id: "shard1_rs",
  members: [
    { _id : 0, host : "192.168.1.38:30201" },
  ]
})

// on mongodb-shard-2
rs.initiate({
  _id: "shard2_rs",
  members: [
    { _id : 0, host : "192.168.1.38:30202" },
  ]
})
```

```javascript
// on mongodb-router
sh.addShard("shard1_rs/192.168.1.38:30201")
sh.addShard("shard2_rs/192.168.1.38:30202")
```