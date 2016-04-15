var ZongJi = require('zongji');

var zongji = new ZongJi({
  host     : 'localhost',
  user     : 'root',
  password : '',
  // debug: true
});

zongji.on('binlog', function(evt) {
  changes(evt, function (err, before, after) {
    if (!err)
      console.log(JSON.stringify(before)+' -> '+JSON.stringify(after))
  })
  //evt.dump()
});

var changes = function (evt, callback) {
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

zongji.start({
  includeEvents: ['tablemap','writerows', 'updaterows', 'deleterows'],
  includeSchema: {'menuweb':['mewpae']}
});

process.on('SIGINT', function() {
  console.log('Got SIGINT.');
  zongji.stop();
  process.exit();
});