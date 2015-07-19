#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"

#include "jpeg.hpp"

class ImageImport : public Closure {
public:
  ImageImport(std::string &id, pp::VarArray &arguments, pp::VarDictionary &library, pp::Instance *instance)
    : Closure(id, arguments, instance), library(library), url_loader(instance), callback_factory(this) {
    Create();
  }
protected:
  std::string url;
  std::string extension;
  pp::VarDictionary library;
  pp::URLLoader url_loader;
  pp::CompletionCallbackFactory<ImageImport> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;

  void Create()
  {
    url = arguments.Get(0).AsString();
    extension = url.substr(std::min<size_t>(url.rfind("."), url.length()));
    results.Set("url", url);
    results.Set("extension", extension);

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
    results.Set("headers", response.GetHeaders());
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
    OnDone(PP_OK);
    return;
    
    if (result != PP_OK) {
      OnDone(result);
      return;
    }

    pp::VarDictionary image;
    if (extension == ".png") {
    }
    else if (extension == ".jpeg" || extension == ".jpg") {
      int32_t result = JPEG_Decode(&data[0], data.size(), image);
      if (result != PP_OK) {
        OnDone(result);
      }
    }
    else {
      OnDone(PP_ERROR_BADRESOURCE);
    }

    library.Set(url, image);
    OnDone(PP_OK);
  }
};
