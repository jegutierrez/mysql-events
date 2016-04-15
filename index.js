var ZongJi = require('zongji');
var socketio = require('socket.io')
var express = require('express')
var http = require('http')

var port = 3000
var app = express()
var server = http.createServer(app)
var io = socketio(server)

server.listen(port, function(){
  console.log('Listen on port '+port)
})

io.on('connection', function(socket){
  console.log('Nueva conexion '+socket.id)
  newMysqlEvents(socket)
})

var _changes = function (evt, callback) {
  before = []
  after = []
  if (evt.rows !== undefined) {
    for (var key in evt.rows[0].before) {
      if (evt.rows[0].before[key] !== evt.rows[0].after[key]) {
        before.push(evt.rows[0].before[key])
        after.push(evt.rows[0].after[key])
      }
    }
    callback(null, before, after)
  }
  callback('error', null)
}
  

var newMysqlEvents = function (socket) {
  var zongji = new ZongJi({
    host     : 'localhost',
    user     : 'root',
    password : '',
    // debug: true
  });

  zongji.start({
    includeEvents: ['tablemap','writerows', 'updaterows', 'deleterows'],
    includeSchema: {'menuweb':['mewpae']}
  });

  process.on('SIGINT', function() {
    console.log('Got SIGINT.');
    zongji.stop();
    process.exit();
  });
  zongji.on('binlog', function(evt) {
    _changes(evt, function (err, before, after) {
      if (!err) {
        console.log(JSON.stringify(before)+' -> '+JSON.stringify(after))
        socket.emit('deli')
      }
    })
    //evt.dump()
  });

}