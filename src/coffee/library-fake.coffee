
module.exports = (module_, concurrency_=4)->
  library_ = {}

  call_ = (function_, arguments_=[], attachments_=null, callback_=null)->
    results_ = module_[function_].apply null, arguments_
    if callback_
      callback_ results_, attachments_
    null

  __barrier__ = (callback_)->
    if callback_
      callback_()
    null

  __profile__ = ()->

  # load module
  factory_ = (function_)-> (arguments_, attachments_, callback_)->
    call_ function_, arguments_, attachments_, callback_
  for key_ of module_
    library_[key_] = factory_(key_)
  library_.__barrier__ = __barrier__
  library_.__profile__ = __profile__
  library_
