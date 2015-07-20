###
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
###

interface = new Interface(self);
interface.method(method_1);
interface.method(method_2);
interface.method(method_3);
interface.object(object_1);
interface.object(object_2);

session = new Session(worker);
handler_1 = new session.object_1();
handler_2 = new session.object_2();
session.method_1(handler_1);
session.method_2(handler_2);
handler_1.free();
handler_1.free();
session.close();
