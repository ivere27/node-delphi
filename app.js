'use strict'

// print toby.version
console.log(`node :: toby.version = ${toby.version}`);

var num = 42;
var foo = 'foo';

toby.on('test', function(x){
  console.log(`node :: toby.on(test) = ${x}`);
});

var result = toby.hostCall('dory', {num, foo});
console.log(`node :: toby.hostCall() = ${result}`);


// var cluster = require('cluster');
// cluster.on('c', function(x){console.log(`node :: x`)});
// if (cluster.isMaster) {
//   console.log('node :: im master');
//   cluster.fork();
//   cluster.emit('c', 'greeting from parent :)')
// } else {
//   console.log('node :: im slave. bye bye');
//   cluster.emit('c','greeting from child :o')
//   process.exit(0);
// }


// exit after 2 secs
(function(){setTimeout(function(){
  process.exitCode = 42;
},2000)})();