#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

class URLFile {
public:
  URLFile(const std::string &url, pp::Instance *instance)
    : loader(instance), request(instance), callback_factory(this) {
    request.SetURL(url);
    request.SetMethod("GET");
    pp::CompletionCallback callback
      = callback_factory.NewCallback(&URLFile::OnOpen);
    loader.Open(request, callback);
  }

protected:
  pp::URLLoader loader;
  pp::URLRequestInfo request;
  pp::URLResponseInfo response;
  pp::CompletionCallbackFactory<URLFile> callback_factory;

  void OnOpen(int32_t result) {
    response = loader.GetResponseInfo();
    if (response.GetStatusCode() != 200) {
      return;
    }
    pp::CompletionCallback callback
      = callback_factory.NewCallback(&URLFile::OnRead);
    //loader.ReadResponseBody(, , callback);
  }

  void OnRead(int32_t result) {
  }
};