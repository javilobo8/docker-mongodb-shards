# MongoDB Cluster with Docker Compose

A simple mongodb cluster with 1 config server, 2 shard servers and 1 router.

# Preparation

Generate keyfile for replica set.

```bash
openssl rand -base64 741 > ./data/replica-keyfile
chmod 600 ./data/replica-keyfile
```

# Installation

First of all, comment out the `--keyFile` option in `compose.yml`.

## Config Server

```bash
docker compose up -d mongodb-config-1
```

```bash
docker exec -it mongodb-config-1 mongosh
```

Init replica set in config server.

```javascript
rs.initiate({
  _id: "config_rs",
  configsvr: true,
  members: [
    { _id : 0, host : "192.168.1.38:30101" },
  ]
})
rs.status()
```

Add superuser to config server in admin database.

```bash
docker exec -it mongodb-config-1 mongosh
```

```javascript
use admin
db.createUser({
  user: "root",
  pwd: "password",
  roles: [{"role":"root","db":"admin"}],
})
```

Uncomment the `--keyFile` option in `compose.yml` and restart config server.

## Router and Shards

```bash
docker compose up -d
```

## For each shard

Init replica set in shard server.

```javascript
// on mongodb-shard-1
rs.initiate({
  _id: "shard1_rs",
  members: [
    { _id : 0, host : "192.168.1.38:30201" },
  ]
})
```

Add shard to router.

```javascript
// on mongodb-router
sh.addShard("shard1_rs/192.168.1.38:30201")
```