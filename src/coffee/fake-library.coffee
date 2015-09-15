
module.exports = (module_, concurrency_=4)->

  call_ = (function_, arguments_=[], attachments_=null, callback_=null)->
    results_ = function_ arguments_
    callback_ results_, attachments_
    null

  __barrier__ = (callback_)->
    callback_()
    null

  __profile__ = ()->

  # load module
  factory_ = (function_)-> (arguments_, attachment_, callback_)->
    call_ function_, arguments_, attachment_, callback_
  for key_ of module_
    library_[key_] = factory_(key_)
  library_.__barrier__ = __barrier__
  library_.__profile__ = __profile__
  library_
