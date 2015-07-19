#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"

#include "jpeg.hpp"

#include <sstream>

class ImageImport : public Closure {
public:
  ImageImport(std::string &id, pp::VarArray &arguments, pp::VarDictionary &library, pp::Instance *instance)
    : Closure(id, arguments, instance), library(library), url_loader(instance), callback_factory(this) {
    Create();
  }
protected:
  pp::VarDictionary library;
  pp::VarDictionary headers;
  pp::URLLoader url_loader;
  pp::CompletionCallbackFactory<ImageImport> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;

  void Create()
  {
    std::string url = arguments.Get(0).AsString();
    results.Set("url", url);

    pp::URLRequestInfo url_request(instance);
    url_request.SetURL(url);
    url_request.SetMethod("GET");
    url_request.SetAllowCrossOriginRequests(true);
    url_request.SetFollowRedirects(true);

    pp::CompletionCallback on_open
      = callback_factory.NewCallback(&ImageImport::OnOpen);
    int32_t result = url_loader.Open(url_request, on_open);

    if (PP_OK_COMPLETIONPENDING != result) {
      on_open.Run(result);
    }
  }

  void OnOpen(int32_t result)
  {
    if (result != PP_OK) {
      OnDone(result);
      return;
    }
    pp::URLResponseInfo response = url_loader.GetResponseInfo();
    if (response.is_null()) {
      OnDone(PP_ERROR_FILENOTFOUND);
      return;
    }
    // parse http headers
    std::stringstream stream(response.GetHeaders().AsString());
    std::string token;
    while(std::getline(stream, token, '\n')) {
      size_t pos = token.find(": ");
      if (pos == -1) {
        continue;
      }
      std::string key = token.substr(0, pos);
      std::string value = token.substr(pos+2, token.size()-pos-2);
      headers.Set(key, value);
    }
    results.Set("headers", headers);
    results.Set("status_code", response.GetStatusCode());
    results.Set("status_line", response.GetStatusLine());
    if (response.GetStatusCode() != 200) {
      OnDone(PP_ERROR_FILENOTFOUND);
      return;
    }
    Read();
  }

  void OnRead(int32_t result)
  {
    if (result == 0) {
      OnLoad(result);
      return;
    }
    int32_t size = std::min<int32_t>(result, sizeof(buffer));
    data.reserve(data.size()+size);
    data.insert(data.end(), buffer, buffer+size);
    results.Set("size", (int)data.size());

    Read();
  }

  void Read()
  {
    pp::CompletionCallback on_read
      = callback_factory.NewCallback(&ImageImport::OnRead);
    int32_t result = url_loader.ReadResponseBody(
      buffer, sizeof(buffer), on_read);

    if (PP_OK_COMPLETIONPENDING != result) {
      on_read.Run(result);
    }
  }

  void OnLoad(int32_t result)
  {
    if (result != PP_OK) {
      OnDone(result);
      return;
    }

    std::string url = arguments.Get(0).AsString();
    std::string type;
    if (headers.HasKey("Content-Type")) {
      type = headers.Get("Content-Type").AsString();
    } else if (headers.HasKey("content-type")) {
      type = headers.Get("content-type").AsString();
    }

    if (type == "image/jpeg") {
      pp::VarDictionary image;
      int32_t result = JPEG_Decode(&data[0], data.size(), image);
      if (result != PP_OK) {
        OnDone(result);
      }
      library.Set(url, image);
      OnDone(PP_OK);
    }
    else {
      OnDone(PP_ERROR_BADRESOURCE);
    }
  }
};
