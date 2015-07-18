'use strict';

var through = require('through2');
var gutil = require('gulp-util');
var PluginError = gutil.PluginError;

module.exports = function(options){
  var opts = options || {};

  function CompileNaCl(file, enc, cb){
    opts.filename = file.path;

    if (file.data) {
      opts.data = file.data;
    }

    if(file.isStream()){
      return cb(new PluginError('gulp-nacl', 'Streaming not supported'));
    }

    if(file.isBuffer()){
      try {
        //file.contents = new Buffer(handleCompile(String(file.contents), opts));
      } catch(e) {
        return cb(new PluginError('gulp-nacl', e));
      }
    }
    cb(null, file);
  }

  return through.obj(CompileJade);
};
