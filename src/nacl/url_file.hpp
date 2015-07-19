#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"

class URLFile {
public:
  URLFile(std::string url, pp::Instance *instance)
    : loader(instance), request(instance), cc_factory(this) {
    //
  }

protected:
  pp::URLLoader loader;
  pp::URLRequestInfo request;
  pp::URLResponseInfo response;
  pp::CompletionCallbackFactory<URLFile> cc_factory;
};