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

#include <stdio.h>
#include <sys/mount.h>
#include <sys/stat.h>

#include <sstream>

#include "nacl_io/nacl_io.h"

#include <png.h>
#include <jpeglib.h>

namespace {

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

    // nacl_io
    nacl_io_init();
    int flickr = mount("https://farm1.staticflickr.com/", "/mnt/flickr", "httpfs", 0, "");
    int cdnjs = mount("https://cdnjs.cloudflare.com/ajax/libs/", "/mnt/cdnjs", "httpfs", 0, "");
    method_library.Set("_flickr", flickr);
    method_library.Set("_cdnjs", cdnjs);
  }
  virtual ~FeatureInstance() {}

  virtual void HandleMessage(const pp::Var& var) {
    if (!var.is_dictionary())
      return;

    pp::VarDictionary request(var);
    pp::VarDictionary response;

    if (!request.HasKey("id")) return;
    response.Set("id", request.Get("id"));

    if (!request.HasKey("method")) return;
    std::string method = request.Get("method").AsString();

    if (!request.HasKey("arguments")) return;
    pp::VarArray arguments(request.Get("arguments"));


    if (method == "_interface") {
      response.Set("results", method_library);
    }
    else if (method == "image_import") {
      std::string library = arguments.Get(0).AsString();
      std::string filename = arguments.Get(1).AsString();

      std::ostringstream stream;
      stream << "/mnt/" << library << "/" << filename;
      std::string path = stream.str();

      //struct stat buf;
      //memset(&buf, 0, sizeof(buf));
      //stat(path.c_str(), &buf);

      pp::VarDictionary results;
      results.Set("args", arguments);
      results.Set("path", path.c_str());
      //results.Set("size", (int)buf.st_size);

      response.Set("results", results);
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

    PostMessage(response);
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
