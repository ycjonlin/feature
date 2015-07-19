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

#include "ppapi/c/pp_errors.h"

#include "ppapi/cpp/instance.h"
#include "ppapi/cpp/module.h"
#include "ppapi/cpp/var.h"
#include "ppapi/cpp/var_array.h"
#include "ppapi/cpp/var_array_buffer.h"
#include "ppapi/cpp/var_dictionary.h"
#include "ppapi/cpp/url_loader.h"
#include "ppapi/cpp/url_request_info.h"
#include "ppapi/cpp/url_response_info.h"
#include "ppapi/utility/completion_callback_factory.h"

namespace {

class URLFile {
protected:
  pp::CompletionCallbackFactory<URLFile> factory;
  pp::URLLoader loader;
  pp::URLRequestInfo request;
  pp::URLResponseInfo response;
  std::string payload;
public:
  explicit URLFile(pp::Var &url, pp::Instance *instance)
    : factory(this), loader(instance), request(instance) {
    request.SetURL(url);
    request.SetMethod("GET");
    request.SetRecordDownloadProgress(true);
    pp::CompletionCallback callback = 
      factory.NewCallback(&URLFile::OnOpen);
    loader.Open(request, callback);
  }

  void OnOpen(int32_t result) {
    if (result != PP_OK) {
      return;
    }

    int64_t received_bytes = 0;
    int64_t total_bytes = 0;
    if (loader.GetDownloadProgress(&received_bytes, &total_bytes)) {
      if (total_bytes > 0) {
        payload.reserve(total_bytes);
      }
    }
    request.SetRecordDownloadProgress(false);
  }
};

}  // namespace

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
    method_library.Set("array_srgb", "");
    method_library.Set("array_cie_rgb", "");
    method_library.Set("array_cie_xyz", "");
    method_library.Set("array_grayscale", "");
    // array to array
    method_library.Set("array_integral", "");
    method_library.Set("array_convolute", "");
    method_library.Set("matrix_trace", "");
    method_library.Set("matrix_determinant", "");
    method_library.Set("matrix_gaussian", "");
    // array to cloud
    method_library.Set("array_suppress_6", "");
    method_library.Set("array_suppress_26", "");
    // cloud to cloud
    method_library.Set("cloud_sort", "");
    method_library.Set("cloud_match", "");
  }
  virtual ~FeatureInstance() {}

  virtual void HandleMessage(const pp::Var& var) {
    if (!var.is_dictionary())
      return;

    pp::VarDictionary dictionary(var);

    if (!dictionary.HasKey("method")) return;
    std::string method = dictionary.Get("method").AsString();

    if (!dictionary.HasKey("arguments")) return;
    pp::VarArray arguments(dictionary.Get("arguments"));

    if (method == "_interface") {
      dictionary.Set("results", method_library);
    }
    else if (method == "image_import") {
      pp::Var url = arguments.Get(0);
      
    }
    else if (method == "array_integral") {
      float* dst = static_cast<float*>(pp::VarArrayBuffer(arguments.Get(0)).Map());
      float* src = static_cast<float*>(pp::VarArrayBuffer(arguments.Get(1)).Map());
      int i_count = arguments.Get(2).AsInt();
      int i_step  = arguments.Get(3).AsInt();
      int j_count = arguments.Get(4).AsInt();
      int j_step  = arguments.Get(5).AsInt();
      array_integral(dst, src, i_count, i_step, j_count, j_step);
    }

    PostMessage(dictionary);
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
