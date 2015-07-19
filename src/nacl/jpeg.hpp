#include <jpeglib.h>
#include <setjmp.h>

struct my_error_mgr {
  struct jpeg_error_mgr pub;
  jmp_buf setjmp_buffer;
};
typedef struct my_error_mgr * my_error_ptr;

METHODDEF(void)
my_error_exit (j_common_ptr cinfo)
{
  my_error_ptr myerr = (my_error_ptr) cinfo->err;
  (*cinfo->err->output_message) (cinfo);
  longjmp(myerr->setjmp_buffer, 1);
}

int32_t JPEG_Decode(uint8_t *data, size_t length, pp::VarDictionary &image)
{
  struct jpeg_decompress_struct cinfo;
  struct my_error_mgr jerr;
  JSAMPARRAY buffer;
  int row_stride, image_size;

  cinfo.err = jpeg_std_error(&jerr.pub);
  jerr.pub.error_exit = my_error_exit;
  if (setjmp(jerr.setjmp_buffer)) {
    jpeg_destroy_decompress(&cinfo);
    return -1;
  }

  jpeg_create_decompress(&cinfo);
  jpeg_mem_src(&cinfo, data, length);
  (void) jpeg_read_header(&cinfo, TRUE);
  (void) jpeg_start_decompress(&cinfo);
  row_stride = cinfo.output_width * cinfo.output_components;
  image_size = cinfo.output_height * cinfo.output_width * 4;

  // JS: Image Array
  pp::VarArrayBuffer array_buffer(image_size);
  uint32_t *array_buffer_ptr = (uint32_t*)array_buffer.Map();

  buffer = (*cinfo.mem->alloc_sarray)
    ((j_common_ptr) &cinfo, JPOOL_IMAGE, row_stride, 1);
  while (cinfo.output_scanline < cinfo.output_height) {
    (void) jpeg_read_scanlines(&cinfo, buffer, 1);

    /*uint8_t *byte = buffer[0];
    if (cinfo.output_components == 3) { // RGB data
      for (int i=0; i<cinfo.output_width; i+=1) {
        *array_buffer_ptr = ((byte[0])|(byte[1]<<8)|(byte[2]<<16)|0xff000000);
        array_buffer_ptr += 1;
        byte += 3;
      }
    } else { // Greyscale data
      for (int i=0; i<cinfo.output_width; i+=1) {
        *array_buffer_ptr = ((byte[0])|(byte[0]<<8)|(byte[0]<<16)|0xff000000);
        array_buffer_ptr += 1;
        byte += 1;
      }
    }*/
  }

  (void) jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);

  // JS: Image Object
  image.Set("width", (int)cinfo.output_width);
  image.Set("height", (int)cinfo.output_height);
  image.Set("buffer", array_buffer);

  return PP_OK;
}
