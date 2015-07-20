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