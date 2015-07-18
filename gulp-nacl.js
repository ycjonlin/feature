var through = require('through');
var gutil = require('gulp-util');
var PluginError = gutil.PluginError;

const PLUGIN_NAME = 'gulp-nacl';

function naclStream(prefixText) {
  var stream = through();
  stream.write(prefixText);
  return stream;
}

function gulpNaCler() {

  var stream = through.obj(function(file, enc, cb) {
    if (file.isBuffer()) {
      //file.contents = Buffer.concat([prefixText, file.contents]);
    }

    if (file.isStream()) {
      var stream = through();
      //stream.write(prefixText);
      stream.on('error', this.emit.bind(this, 'error'));
      file.contents = file.contents.pipe(stream);
    }

    this.push(file);
    cb();
  });

  return stream;
}

module.exports = gulpNaCler;