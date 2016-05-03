'use strict'

const ZongJi = require('zongji');
const socketio = require('socket.io')
const express = require('express')
const http = require('http')

const port = 3000
const app = express()
const server = http.createServer(app)
const io = socketio(server)

app.use(express.static('public'))

server.listen(port, function(){
  console.log('Listen on port '+port)
})

io.on('connection', function(socket){
  console.log('Nueva conexion '+socket.id)
  let conn = {host:'192.168.12.61', user:'root', password: ''}

  socket.on('join', function(data){
    
    console.log('join -> '+ data.codcli + ':' + data.solucion)

    let zongji = new ZongJi({
      host     : conn.host,
      user     : conn.user,
      password : conn.password
    });

    let schema = {}
    schema[data.codcli] = [data.solucion]
    let events = ['tablemap','writerows', 'updaterows', 'deleterows']
  
    zongji.start({
      includeEvents: events,
      includeSchema: schema
    })

    zongji.on('binlog', function(evt) {
      console.log(evt)
      _changes(evt, function (err, before, after) {
        if (!err) {
          console.log(JSON.stringify(before)+' -> '+JSON.stringify(after))
          socket.emit( evt.tableMap[evt.tableId].tableName )
        }
      })
    })

    socket.on('disconnect', function () {
      console.log('Got SIGINT.');
      zongji.stop();
    })

    process.on('SIGINT', function() {
      console.log('Got SIGINT.');
      zongji.stop();
      process.exit();
    })
  })
})

let _changes = function (evt, callback) {
  let before = []
  let after = []
  if (evt.rows !== undefined) {
    for (let key in evt.rows[0].before) {
      if (evt.rows[0].before[key] !== evt.rows[0].after[key]) {
        before.push(evt.rows[0].before[key])
        after.push(evt.rows[0].after[key])
      }
    }
    callback(null, before, after)
  }
  callback('error')
}
