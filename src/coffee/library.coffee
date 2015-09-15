bundleFn = arguments[3]
sources = arguments[4]
cache = arguments[5]

sourcify = (data)->
  type = typeof data
  if type == 'function'
    return data.toString()
  if type == 'object'
    source = ''
    for key, value of data
      source += "#{JSON.stringify(key)}:#{sourcify(value)},"
    return "{#{source}}"
  if type == 'array'
    source = ''
    for value in data
      source += "#{sourcefiy(value)},"
    return "[#{source}]"
  return JSON.stringify(data)

module.exports = (module_, concurrency_=4)->
  idle_ = []
  queue_ = []
  registry_ = {}
  serial_ = 0
  barrier_ = 0
  profile_ = {}
  library_ = {}
  interval_ = Date.now()

  dispatch_ = ()->
    while queue_.length > 0
      if queue_[0].function_
        # task could only be removed when some workers are idling
        break if idle_.length == 0
        action_ = queue_.shift()
        register_ = registry_[action_.serial_]
        worker_ = idle_.shift()
        timestamp_ = Date.now()
        worker_.postMessage action_
        register_.timestamp_ = Date.now()
        console.log (register_.timestamp_-timestamp_)+'ms', 'postMessage'
      else
        # barrier could only be removed when all workers are idling
        break if idle_.length < concurrency_
        action_ = queue_.shift()
        register_ = registry_[action_.serial_]
        delete registry_[action_.serial_]
        latency_ = Date.now()-interval_
        interval_ = interval_+latency_
        console.log latency_+'ms', '__barrier__'
        if register_.callback_
          register_.callback_()
    null

  call_ = (function_, arguments_=[], attachments_=null, callback_=null)->
    # setup register
    call_serial_ = ''+serial_; serial_ += 1
    register_ =
      attachments_: attachments_
      callback_: callback_
      timestamp_: null
    registry_[call_serial_] = register_
    # setup action
    action_ =
      serial_: call_serial_
      function_: function_
      arguments_: arguments_
      results_: null
    queue_.push action_
    # assign to a worker or queue
    dispatch_()
    null

  return_ = (event_)->
    # rest worker
    worker_ = event_.target
    idle_.push worker_
    # release action
    action_ = event_.data
    register_ = registry_[action_.serial_]
    delete registry_[action_.serial_]
    # record latency
    latency_ = Date.now()-register_.timestamp_
    profile_[action_.function_] += latency_
    console.log latency_+'ms', action_.function_
    # invoke callback
    if register_.callback_ != null
      register_.callback_ action_.results_, register_.attachments_
    # dispatch
    dispatch_()
    null

  __barrier__ = (callback_)->
    # place barrier
    barrier_ = barrier_ + 1
    call_ null, [], null, callback_
    # dispatch
    dispatch_()
    null

  __profile__ = ()->
    for key in Object.keys(profile_).sort((key)->profile_[key])
      console.log profile_[key]+'ms', key

  # use as source
  marshal_ = (self, path)->
    module = require path
    self.addEventListener 'message', (event)->
      action_ = event.data
      function_ = module[action_.function_]
      action_.results_ = function_.apply null, action_.arguments_
      action_.arguments_ = null
      self.postMessage action_
    null

  # create workers
  for path, value of cache
    break if value.exports == module_
  sources['library'] = [Function(['require', 'module', 'exports'],
    "(#{marshal_})(self,#{sourcify(path)})"), {}]
  source_ = "(#{bundleFn})(#{sourcify(sources)},{},['library'])"
  url_ = URL.createObjectURL(new Blob([source_], {type: 'text/javascript'}))
  for i in [1..concurrency_]
    worker_ = new Worker(url_)
    worker_.addEventListener 'message', return_
    idle_.push worker_

  # load profile
  for key_ of module_
    profile_[key_] = 0

  # load module
  factory_ = (function_)-> (arguments_, attachments_, callback_)->
    call_ function_, arguments_, attachments_, callback_
  for key_ of module_
    library_[key_] = factory_(key_)
  library_.__barrier__ = __barrier__
  library_.__profile__ = __profile__
  library_
