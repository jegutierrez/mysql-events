var ZongJi = require('zongji');

var zongji = new ZongJi({
  host     : 'localhost',
  user     : 'root',
  password : '',
  // debug: true
});

zongji.on('binlog', function(evt) {
  evt.dump();
});

zongji.start({
  includeEvents: ['tablemap', 'writerows', 'updaterows', 'deleterows'],
  includeSchema: {'maxilist':['clientes']}

process.on('SIGINT', function() {
  console.log('Got SIGINT.');
  zongji.stop();
  process.exit();
});