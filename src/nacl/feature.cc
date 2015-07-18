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

namespace {

// The expected string sent by the browser.
const char* const kHelloString = "hello";
// The string sent back to the browser upon receipt of a message
// containing "hello".
const char* const kReplyString = "hello from NaCl";

}  // namespace

class FeatureInstance : public pp::Instance {
 public:
  explicit FeatureInstance(PP_Instance instance)
      : pp::Instance(instance) {}
  virtual ~FeatureInstance() {}

  virtual void HandleMessage(const pp::Var& var_message) {
    // Ignore the message if it is not a string.
    if (!var_message.is_string())
      return;

    // Get the string message and compare it to "hello".
    std::string message = var_message.AsString();
    if (message == kHelloString) {
      // If it matches, send our response back to JavaScript.
      pp::Var var_reply(kReplyString);
      PostMessage(var_reply);
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
