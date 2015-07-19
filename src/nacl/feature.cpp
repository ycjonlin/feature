void array_integral(
  float *dst, float *src, 
  int i_count, int i_step, 
  int j_count, int j_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    float sum = 0.0f;
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      sum += src[j];
      dst[j] = sum;
    }
  }
}

void array_convolute(
  float *dst, float *src, float *krn, 
  int i_count, int i_step, 
  int j_count, int j_step, 
  int k_count, int k_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      float sum = 0.0f;
      for (int _k=0, k=j; _k<k_count; _k+=1, k+=k_step) {
        sum += src[k]*krn[_k];
      }
      dst[j] = sum;
    }
  }
}

void array_suppress_6(
  int *dst, float *src_f, float *src_m, float *src_b, 
  int i_count, int i_step, 
  int j_count, int j_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int score = 0;
      float base = src_m[j];
      score += src_m[j-i_step] < base ? -1 : 1;
      score += src_m[j+i_step] < base ? -1 : 1;
      score += src_m[j-j_step] < base ? -1 : 1;
      score += src_m[j+j_step] < base ? -1 : 1;
      score += src_f[j] < base ? -1 : 1;
      score += src_b[j] < base ? -1 : 1;
      if (score == -6 || score == 6) {
        dst[0] = j;
        dst += 1;
      }
    }
  }
}

void array_suppress_26(
  int *dst, float *src_f, float *src_m, float *src_b, 
  int i_count, int i_step, 
  int j_count, int j_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int score = 0;
      float base = src_m[j];

      score += src_m[j-i_step-j_step] < base ? -1 : 1;
      score += src_m[j-i_step       ] < base ? -1 : 1;
      score += src_m[j-i_step+j_step] < base ? -1 : 1;
      score += src_m[j       -j_step] < base ? -1 : 1;
      score += src_m[j              ] < base ? -1 : 1;
      score += src_m[j       +j_step] < base ? -1 : 1;
      score += src_m[j+i_step-j_step] < base ? -1 : 1;
      score += src_m[j+i_step       ] < base ? -1 : 1;
      score += src_m[j+i_step+j_step] < base ? -1 : 1;

      score += src_f[j-i_step-j_step] < base ? -1 : 1;
      score += src_f[j-i_step       ] < base ? -1 : 1;
      score += src_f[j-i_step+j_step] < base ? -1 : 1;
      score += src_f[j       -j_step] < base ? -1 : 1;
      score += src_f[j       +j_step] < base ? -1 : 1;
      score += src_f[j+i_step-j_step] < base ? -1 : 1;
      score += src_f[j+i_step       ] < base ? -1 : 1;
      score += src_f[j+i_step+j_step] < base ? -1 : 1;

      score += src_b[j-i_step-j_step] < base ? -1 : 1;
      score += src_b[j-i_step       ] < base ? -1 : 1;
      score += src_b[j-i_step+j_step] < base ? -1 : 1;
      score += src_b[j       -j_step] < base ? -1 : 1;
      score += src_b[j              ] < base ? -1 : 1;
      score += src_b[j       +j_step] < base ? -1 : 1;
      score += src_b[j+i_step-j_step] < base ? -1 : 1;
      score += src_b[j+i_step       ] < base ? -1 : 1;
      score += src_b[j+i_step+j_step] < base ? -1 : 1;

      if (score == -26 || score == 26) {
        dst[0] = j;
        dst += 1;
      }
    }
  }
}

void matrix_trace(
  float *dst, 
  float *src, float *src_x, float *src_y, 
  float *src_xx, float *src_xy, float *src_yy, 
  int i_count, int i_step, 
  int j_count, int j_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      dst[j] = src_xx[j]+src_yy[j];
    }
  }
}

void matrix_determinant(
  float *dst, 
  float *src, float *src_x, float *src_y, 
  float *src_xx, float *src_xy, float *src_yy, 
  int i_count, int i_step, 
  int j_count, int j_step) {
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      dst[j] = src_xx[j]*src_yy[j]-src_xy[j]*src_xy[j];
    }
  }
}

// module code

#include "ppapi/cpp/instance.h"
#include "ppapi/cpp/module.h"
#include "ppapi/cpp/var.h"
#include "ppapi/cpp/var_array.h"
#include "ppapi/cpp/var_array_buffer.h"
#include "ppapi/cpp/var_dictionary.h"

#include <png.h>
#include <jpeglib.h>

#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

namespace {

}  // namespace

class Closure {
public:
  Closure(std::string &id, pp::VarArray &arguments, pp::Instance *instance)
    : id(id), arguments(arguments), instance(instance) {}
  virtual ~Closure() {}
protected:
  std::string id;
  pp::VarArray arguments;
  pp::VarDictionary results;
  pp::Instance *instance;

  void OnDone(int32_t result) {
    pp::VarDictionary response;
    response.Set("id", id);
    results.Set("code", result);
    response.Set("results", results);
    (*instance).PostMessage(response);

    delete this;
  }
};

class ImageImport : public Closure {
public:
  ImageImport(std::string &id, pp::VarArray &arguments, pp::Instance *instance)
    : Closure(id, arguments, instance), url_loader(instance), callback_factory(this) {
    Create();
  }
protected:
  pp::URLLoader url_loader;
  pp::CompletionCallbackFactory<ImageImport> callback_factory;

  uint8_t buffer[1<<16];
  std::vector<uint8_t> data;

  void Create()
  {
    std::string url = arguments.Get(0).AsString();
    pp::URLRequestInfo url_request(instance);
    url_request.SetURL(url);
    url_request.SetMethod("GET");
    url_request.SetProperty(PP_URLREQUESTPROPERTY_ALLOWCROSSORIGINREQUESTS, true);
    url_request.SetProperty(PP_URLREQUESTPROPERTY_FOLLOWREDIRECTS, true);

    pp::CompletionCallback on_open
      = callback_factory.NewCallback(&ImageImport::OnOpen);
    int32_t result = url_loader.Open(url_request, on_open);

    if (PP_OK_COMPLETIONPENDING != result)
      on_open.Run(result);
  }

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
      OnLoad(result);
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
    std::string extension = url.substr(
      std::min<size_t>(url.rfind("."), url.length()));
    results.Set("url", url);
    results.Set("extension", extension);
    results.Set("size", (int)data.size());

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
    struct jpeg_decompress_struct cinfo;

    jpeg_create_decompress(&cinfo);
    jpeg_mem_src(&cinfo, &data[0], data.size());
    (void) jpeg_read_header(&cinfo, TRUE);
    (void) jpeg_start_decompress(&cinfo);

   /* int row_stride = cinfo.output_width * cinfo.output_components;
    std::vector<uint8_t> image(cinfo.output_height * row_stride);

    while (cinfo.output_scanline < cinfo.output_height) {
      uint8_t *buffer_array[1];
      buffer_array[0] = &image[cinfo.output_scanline * row_stride];
      jpeg_read_scanlines(&cinfo, buffer_array, 1);
    }*/

    (void) jpeg_finish_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);

    OnDone(PP_OK);
  }
};

class FeatureInstance : public pp::Instance {
protected:
  pp::VarDictionary method_library;
  pp::VarDictionary image_library;
  pp::VarDictionary array_library;

 public:
  explicit FeatureInstance(PP_Instance instance)
      : pp::Instance(instance) {
    // image manipulation
    method_library.Set("image_import", "");
    method_library.Set("image_export", "");
    method_library.Set("image_free", "");
    // array manipulation
    method_library.Set("array_export", "");
    method_library.Set("array_free", "");
    // array manipulation
    method_library.Set("cloud_export", "");
    method_library.Set("cloud_free", "");
    // image to array
    method_library.Set("split_srgb", "");
    method_library.Set("split_cie_rgb", "");
    method_library.Set("split_cie_xyz", "");
    method_library.Set("split_grayscale", "");
    // calculus
    method_library.Set("calculus_integral", "");
    method_library.Set("calculus_convolute", "");
    method_library.Set("calculus_differential", "");
    // array to cloud
    method_library.Set("matrix_trace", "");
    method_library.Set("matrix_determinant", "");
    method_library.Set("matrix_gaussian", "");
    // array to cloud
    method_library.Set("suppress_6_neighbors", "");
    method_library.Set("suppress_26_neighbors", "");
  }
  virtual ~FeatureInstance() {}

  virtual void HandleMessage(const pp::Var& var) {

    if (!var.is_dictionary()) return;

    const pp::VarDictionary request(var);
    if (!request.HasKey("id") 
     || !request.HasKey("method") 
     || !request.HasKey("arguments")) {
      return;
    }

    std::string id = request.Get("id").AsString();
    std::string method = request.Get("method").AsString();
    pp::VarArray arguments(request.Get("arguments"));


    if (method == "_interface")
    {
      pp::VarDictionary response;
      response.Set("id", id);
      response.Set("results", method_library);
      PostMessage(response);
    }
    else if (method == "image_import")
    {
      new ImageImport(id, arguments, this);
    }
    else if (method == "array_integral")
    {
      std::string dst = arguments.Get(0).AsString();
      std::string src = arguments.Get(1).AsString();
      int i_count = arguments.Get(2).AsInt();
      int i_step  = arguments.Get(3).AsInt();
      int j_count = arguments.Get(4).AsInt();
      int j_step  = arguments.Get(5).AsInt();
      //array_integral(dst, src, i_count, i_step, j_count, j_step);

      pp::VarDictionary response;
      response.Set("session", request.Get("session"));
      PostMessage(response);
    }
  }
};

class FeatureModule : public pp::Module {
 public:
  FeatureModule() : pp::Module() {}
  virtual ~FeatureModule() {}

  virtual pp::Instance* CreateInstance(PP_Instance instance) {
    return new FeatureInstance(instance);
  }
};

namespace pp {

Module* CreateModule() {
  return new FeatureModule();
}

}  // namespace pp
