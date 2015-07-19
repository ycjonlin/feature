static float linear[256] = {0};

void split_srgb(
  float *dst_r, float *dst_g, float *dst_b, int *src_i,
  int i_count, int i_step, 
  int j_count, int j_step) {
  int idx = 0;
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int color = src_i[idx];
      dst_r[j] = (float)((color>> 0)&0xff)/255;
      dst_g[j] = (float)((color>> 8)&0xff)/255;
      dst_b[j] = (float)((color>>16)&0xff)/255;
      idx += 1;
    }
  }
}

void split_cie_rgb(
  float *dst_r, float *dst_g, float *dst_b, int *src_i,
  int i_count, int i_step, 
  int j_count, int j_step) {
  int idx = 0;
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int color = src_i[idx];
      dst_r[j] = linear[(color>> 0)&0xff];
      dst_g[j] = linear[(color>> 8)&0xff];
      dst_b[j] = linear[(color>>16)&0xff];
      idx += 1;
    }
  }
}

void split_cie_xyz(
  float *dst_x, float *dst_y, float *dst_z, int *src_i,
  int i_count, int i_step, 
  int j_count, int j_step) {
  int idx = 0;
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int color = src_i[idx];
      float r = linear[(color>> 0)&0xff];
      float g = linear[(color>> 8)&0xff];
      float b = linear[(color>>16)&0xff];
      dst_x[j] = 0.4124564f*r + 0.3575761f*g + 0.1804375f*b;
      dst_y[j] = 0.2126729f*r + 0.7151522f*g + 0.0721750f*b;
      dst_z[j] = 0.0193339f*r + 0.1191920f*g + 0.9503041f*b;
      idx += 1;
    }
  }
}

void split_grayscale(
  float *dst_g, int *src_i,
  int i_count, int i_step, 
  int j_count, int j_step) {
  int idx = 0;
  for (int _i=0, i=0; _i<i_count; _i+=1, i+=i_step) {
    for (int _j=0, j=i; _j<j_count; _j+=1, j+=j_step) {
      int color = src_i[idx];
      float r = linear[(color>> 0)&0xff];
      float g = linear[(color>> 8)&0xff];
      float b = linear[(color>>16)&0xff];
      dst_g[j] = 0.2126*r + 0.7152*g + 0.0722*b;
      idx += 1;
    }
  }
}

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
#include "ppapi/utility/completion_callback_factory.h"

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

#include "image.hpp"

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
    method_library.Set("image_list", "");
    method_library.Set("image_free", "");
    // array manipulation
    method_library.Set("array_export", "");
    method_library.Set("array_list", "");
    method_library.Set("array_free", "");
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
      new ImageImport(id, arguments, image_library, this);
    }
    else if (method == "split_cie_xyz")
    {
      std::string url = arguments.Get(0).AsString();
      pp::VarDictionary image(image_library.Get(url));

      int width = image.Get("width").AsInt();
      int height = image.Get("height").AsInt();
      int image_size = width * height;
      int array_size = image_size * 16;

      pp::VarArrayBuffer src_buffer(image.Get("buffer"));
      pp::VarArrayBuffer dst_buffer(array_size);

      int   *src_pointer = (  int*)src_buffer.Map();
      float *dst_pointer = (float*)dst_buffer.Map();

      split_cie_xyz(
        dst_pointer + width, 
        dst_pointer + image_size * 2, 
        dst_pointer + width + image_size * 2, 
        src_pointer,
        height, width * 2, width, 1);

      url += " split_cie_xyz";
      array_library.Set(url, dst_buffer);

      pp::VarDictionary response;
      response.Set("id", id);
      response.Set("results", url);
      PostMessage(response);
    }
    else if (method == "calculus_convolute")
    {
      int i_count = arguments.Get(2).AsInt();
      int i_step = arguments.Get(3).AsInt();
      int j_count = arguments.Get(4).AsInt();
      int j_step = arguments.Get(5).AsInt();
      int k_count = arguments.Get(6).AsInt();
      int k_step = arguments.Get(7).AsInt();

      std::string url = arguments.Get(0).AsString();
      pp::VarArrayBuffer src_buffer(array_library.Get(url));
      pp::VarArrayBuffer dst_buffer(src_buffer.ByteLength());
      pp::VarArrayBuffer krn_buffer(arguments.Get(1));

      float *src_pointer = (float*)src_buffer.Map();
      float *dst_pointer = (float*)dst_buffer.Map();
      float *krn_pointer = (float*)krn_buffer.Map();

      split_cie_xyz(
        dst_pointer, src_pointer, krn_pointer,
        i_count, i_step, 
        j_count, j_step, 
        k_count, k_step);

      url += " calculus_convolute";
      array_library.Set(url, dst_buffer);

      pp::VarDictionary response;
      response.Set("id", id);
      response.Set("results", url);
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
