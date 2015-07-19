#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

class URLFile {
public:
  URLFile(
    std::string &url, 
    pp::VarDictionary response,
    pp::Instance *instance) : 
    instance(instance),
    response(response),
    url(url), 
    url_loader(instance), 
    url_request(instance), 
    callback_factory(this)
  {
    response.Set("results", results);
    results.Set("logs", logs);
    logs.Set(logs.GetLength(), url);

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
  std::string url;
  pp::URLLoader url_loader;
  pp::URLRequestInfo url_request;
  pp::CompletionCallbackFactory<URLFile> callback_factory;

  uint8_t buffer[4096];
  std::vector<uint8_t> data;
  pp::CompletionCallback on_done;
  pp::VarDictionary response;
  pp::VarDictionary results;
  pp::VarArray logs;
  pp::Instance *instance;

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

    logs.Set(logs.GetLength(), result);

    Read();
  }

  void OnDone(int32_t result)
  {
    results.Set("code", result);
    (*instance).PostMessage(response);
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
