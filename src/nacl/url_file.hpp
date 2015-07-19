#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

class PostCallback {
public:
  pp::Var message;
  pp::CompletionCallback on_done;

  PostCallback(
    pp::Var message,
    pp::Instance *instance) :
    message(message), 
    instance(instance), 
    callback_factory(this) {
    on_done = callback_factory.NewCallback(&PostCallback::OnDone);
  }

protected:
  pp::Instance *instance;
  pp::CompletionCallbackFactory<PostCallback> callback_factory;

  void OnDone(int32_t result) {
    instance->PostMessage(message);
  }
};

class URLFile {
public:
  URLFile(
    const std::string &url, 
    const pp::CompletionCallback &on_done, 
    pp::Instance *instance) : 
    url(url), 
    on_done(on_done), 
    url_loader(instance), 
    url_request(instance), 
    callback_factory(this)
  {
    url_request.SetURL(url);
    url_request.SetMethod("GET");

    pp::CompletionCallback on_open
      = callback_factory.NewCallback(&URLFile::OnOpen);
    int32_t result = url_loader.Open(url_request, on_open);

    if (PP_OK_COMPLETIONPENDING != result)
      on_open.Run(result);
  }

protected:
  const std::string  url;
  pp::URLLoader      url_loader;
  pp::URLRequestInfo url_request;
  pp::CompletionCallbackFactory<URLFile> callback_factory;

  uint8_t buffer[4096];
  std::vector<uint8_t> data;
  const pp::CompletionCallback on_done;

  void OnOpen(int32_t result)
  {
    if (result != PP_OK) {
      on_done.Run(result);
      return;
    }
    pp::URLResponseInfo response = url_loader.GetResponseInfo();
    if (response.is_null() || response.GetStatusCode() != 200) {
      on_done.Run(result);
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
