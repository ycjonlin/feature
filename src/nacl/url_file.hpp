#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

class URLFile {
public:
  URLFile(
    std::string &url, 
    pp::Instance *instance) : 
    instance(instance),
    url_loader(instance), 
    url_request(instance), 
    callback_factory(this)
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

protected:
  pp::URLLoader url_loader;
  pp::URLRequestInfo url_request;
  pp::CompletionCallbackFactory<URLFile> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;

  void OnOpen(int32_t result)
  {
    if (result != PP_OK) {
      OnDone(result);
      return;
    }
    pp::URLResponseInfo response = url_loader.GetResponseInfo();
    if (response.is_null() || response.GetStatusCode() != 200) {
      OnDone(PP_ERROR_FILENOTFOUND);
      return;
    }
    Read();
  }

  void OnRead(int32_t result)
  {
    if (result == 0) {
      OnDone(result);
      return;
    }
    int32_t size = std::min<int32_t>(result, sizeof(buffer));
    data.reserve(data.size()+size);
    data.insert(data.end(), buffer, buffer+size);

    Read();
  }

  void OnDone(int32_t result)
  {
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
