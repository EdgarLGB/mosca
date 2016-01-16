var mosca = require('mosca');
var cluster = require('cluster');
var numCPUs = require('os').cpus().length;	//obtenir le nombre de CPU

var ascoltatore = {
  //using ascoltatore
  type: 'mongo',        
  url: 'mongodb://' + process.env.MONGODB_PORT_27017_TCP_ADDR + ':27017/mqtt',
  pubsubCollection: 'ascoltatori',
  mongo: {}
};

var moscaSettings = {
  port: 1883,
  backend: ascoltatore,
  persistence: {
    factory: mosca.persistence.Mongo,
//    url: 'mongodb://localhost:27017/mqtt'
  url: 'mongodb://' + process.env.MONGODB_PORT_27017_TCP_ADDR + ':27017/mqtt',
  }
};

if (cluster.isMaster) {
   // Fork workers.
   for (var i = 0; i < numCPUs; i++) {
      cluster.fork();
   }


   cluster.on('death', function(work) {
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
     console.log('process ' + process.pid + ' received message');
     console.log('Published', packet.payload);
   });
}

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running')
}

