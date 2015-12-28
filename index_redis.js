var mosca = require('mosca');
var cluster = require('cluster');
var numCPUs = require('os').cpus().length;	//obtenir le nombre de CPU

console.log(process.env.REDIS_PORT_6379_TCP_ADDR);

var ascoltatore = {
  type: 'redis',
  redis: require('redis'),
  db: 12,
  port: 6379,
  return_buffers: true, // to handle binary payloads
  host: process.env.REDIS_PORT_6379_TCP_ADDR
};

console.log(ascoltatore);

var moscaSettings = {
  port: 1883,
  backend: ascoltatore,
  persistence: {
    factory: mosca.persistence.Redis
  }
};


if (cluster.isMaster) {
   // Fork workers.
   for (var i = 0; i < numCPUs; i++) {
      cluster.fork();
   }
   
   cluster.on('death', function(worker) {
     console.log('worker ' + worker.pid + ' died');
   });
} else {
   // Worker processes have a mosca server.

   var server = new mosca.Server(moscaSettings);
   server.on('ready', setup);

   server.on('clientConnected', function(client) {
       console.log('client connected', client.id);     
   });

   // fired when a message is received
   server.on('published', function(packet, client) {
     console.log('Published', packet.payload);
   });
}

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running')
}
