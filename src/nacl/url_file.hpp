#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

class URLFile {
public:
  URLFile(const std::string &url, pp::Instance *instance)
    : url_loader(instance), url_request(instance), callback_factory(this)
  {
    url_request.SetURL(url);
    url_request.SetMethod("GET");

    pp::CompletionCallback on_open
      = callback_factory.NewCallback(&URLFile::OnOpen);
    int32_t result = url_loader.Open(url_request, on_open);
    if (PP_ERROR_WOULDBLOCK != result)
      on_open.Run(result);
  }

protected:
  pp::CompletionCallbackFactory<URLFile> callback_factory;
  pp::URLLoader url_loader;
  pp::URLRequestInfo url_request;
  std::vector<uint8_t> data;

  void OnOpen(int32_t result)
  {
    if (result != PP_OK) {
      return;
    }
    pp::URLResponseInfo response = url_loader.GetResponseInfo();
    if (response.is_null() || response.GetStatusCode() != 200) {
      return;
    }
    Read();
  }

  void OnRead(int32_t result)
  {
    if (result == 0) {
      return;
    }
    Read();
  }

  void Read()
  {
    pp::CompletionCallback on_read
      = callback_factory.NewCallback(&URLFile::OnRead);
    int32_t result = url_loader.ReadResponseBody(
      buffer, sizeof(buffer), on_read);
    if (PP_ERROR_WOULDBLOCK != result)
      on_read.Run(result);
  }
};
