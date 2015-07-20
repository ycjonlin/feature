/*
(function() {
  var worker = new Worker('worker.js');

  worker.addEventListener('message', function(event) {
    console.log(event.data);
  }, false);

  worker.postMessage('Hello World');
})();


(function() {
  self.addEventListener('message', function(event) {
    self.postMessage(event.data);
  }, false);
})();
*/

function Interface(channel) {
  this.channel = channel;
  this._method = {};
  this._object = {};

  channel.addEventListener('message', function(event) {
    if (!Array.isArray(event.data)) {
      return;
    }
    var identifier = event.data[0];
    if (event.data == '_load') {

    }
  }, false);
}


function Session(path, onload) {
  worker = new Worker(path);
  worker.addEventListener('message', function(event) {
    //
  }, false);
  worker.postMessage([]);
}

function _return(serial, result) {
  var callback = this.callback[serial];
  this.callback[serial] = null;
  callback(result);
}

function _call(identifier, callback, argument) {
  var serial = this.callback.length;
  this.callback[serial] = callback;
  this.channel.postMessage([serial, id, argument]);
}

function _object_factory() {
  function _object() {
    this._call()
  }
}


interface = new Interface(self);
interface.method(function method_1() {});
interface.method(function method_2() {});
interface.method(function method_3() {});
interface.object(function object_1() {});
interface.object(function object_2() {});

session = new Session('worker.js');
handler_1 = new session.object_1();
handler_2 = new session.object_2();
session.method_1(handler_1);
session.method_2(handler_2);
handler_1.free();
handler_1.free();
session.close();
