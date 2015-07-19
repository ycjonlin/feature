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
  pp::VarDictionary library;
  pp::URLLoader url_loader;
  pp::CompletionCallbackFactory<ImageImport> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;

  void Create()
  {
    std::string url = arguments.Get(0).AsString();
    std::string extension = url.substr(
      std::min<size_t>(url.rfind("."), url.length()));
    results.Set("url", url);
    results.Set("extension", extension);

    pp::URLRequestInfo url_request(instance);
    url_request.SetURL(url);
    url_request.SetMethod("GET");
    url_request.SetProperty(PP_URLREQUESTPROPERTY_ALLOWCROSSORIGINREQUESTS, true);
    url_request.SetProperty(PP_URLREQUESTPROPERTY_FOLLOWREDIRECTS, true);

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
    if (response.is_null() || response.GetStatusCode() != 200) {
      results.Set("http_status_code", response.GetStatusCode());
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

    std::string extension = results.Get("extension").AsString();

    if (extension == ".png") {
      PNG();
    }
    else if (extension == ".jpeg" || extension == ".jpg") {
      JPEG();
    }
    else {
      OnDone(PP_ERROR_BADRESOURCE);
    }
  }

  void PNG() {
    OnDone(PP_OK);
  }

  void JPEG() {
    int32_t result = JPEG_Decode(&data[0], data.size());
    OnDone(result);
  }
};
