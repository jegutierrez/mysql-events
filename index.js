'use strict'

const ZongJi = require('zongji');
const socketio = require('socket.io')
const express = require('express')
const http = require('http')

const port = 3000
const app = express()
const server = http.createServer(app)
const io = socketio(server)

server.listen(port, function(){
  console.log('Listen on port '+port)
})

io.on('connection', function(socket){
  console.log('Nueva conexion '+socket.id)
  let conn = {host:'localhost', user:'root', password: 'mysql'}

  socket.on('join', function(data){
    newMysqlEvents(conn, function (err, zongji) {

      let schema = {}
      schema[data.db] = [data.table]
      let events = ['tablemap','writerows', 'updaterows', 'deleterows']
    
      zongji.start({
        includeEvents: events,
        includeSchema: schema
      })

      process.on('SIGINT', function() {
        console.log('Got SIGINT.');
        zongji.stop();
        process.exit();
      })

      zongji.on('binlog', function(evt) {
        _changes(evt, function (err, before, after) {
          if (!err) {
            console.log(JSON.stringify(before)+' -> '+JSON.stringify(after))
            socket.emit('deli')
          }
        })
        //evt.dump()
      })

      socket.on('disconnect', function () {
        console.log('Got SIGINT.');
        zongji.stop();
      })

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
  

let newMysqlEvents = function (conn, callback) {
  let zongji = new ZongJi({
    host     : conn.host,
    user     : conn.user,
    password : conn.password,
    // debug: true
  });
  callback(null, zongji)
}