

class URLFile {
public:
  URLFile(
    std::string &url, 
    pp::CompletionCallback &on_done,
    pp::Instance *instance) : 
    on_done(on_done),
    url_loader(instance), 
    url_request(instance), 
    callback_factory(this)
  {
    OnCreate(PP_OK);
  }

protected:
  pp::URLLoader url_loader;
  pp::URLRequestInfo url_request;
  pp::CompletionCallbackFactory<URLFile> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;
  pp::CompletionCallback on_done;

  void OnCreate(int32_t result)
  {
    url_request.SetURL(url);
    url_request.SetMethod("GET");
    url_request.SetProperty(PP_URLREQUESTPROPERTY_ALLOWCROSSORIGINREQUESTS, true);
    url_request.SetProperty(PP_URLREQUESTPROPERTY_FOLLOWREDIRECTS, true);

    pp::CompletionCallback on_open
      = callback_factory.NewCallback(&URLFile::OnOpen);
    int32_t result = url_loader.Open(url_request, on_open);

    if (PP_OK_COMPLETIONPENDING != result)
      on_open.Run(result);
  }

  void OnOpen(int32_t result)
  {
    if (result != PP_OK) {
      on_done.Run(result);
      return;
    }
    pp::URLResponseInfo response = url_loader.GetResponseInfo();
    if (response.is_null() || response.GetStatusCode() != 200) {
      on_done.Run(PP_ERROR_FILENOTFOUND);
      return;
    }
    Read();
  }

  void OnRead(int32_t result)
  {
    if (result == 0) {
      on_done.Run(result);
      return;
    }
    int32_t size = std::min<int32_t>(result, sizeof(buffer));
    data.reserve(data.size()+size);
    data.insert(data.end(), buffer, buffer+size);

    Read();
  }

  void Read()
  {
    pp::CompletionCallback on_read
      = callback_factory.NewCallback(&URLFile::OnRead);
    int32_t result = url_loader.ReadResponseBody(
      buffer, sizeof(buffer), on_read);

    if (PP_OK_COMPLETIONPENDING != result) {
      on_read.Run(result);
    }
  }
};
