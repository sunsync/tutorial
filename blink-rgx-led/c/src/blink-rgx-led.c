#include <servicesync/moat.h>
#include <stdlib.h>
#include <syslog.h>
#include "blink-rgx-led-debug.h"

#define MOAT_MODEL_LED ("Led")

/*! LEDを点滅させるアプリケーションクラス.
 *
 */
typedef struct TBlinkRgxLedApp_ TBlinkRgxLedApp;
struct TBlinkRgxLedApp_ {
  /*! Moatオブジェクト. */
  Moat fMoat;
};


/*! LEDを点滅させるコマンド関数.
 *
 * \param [in] in_moat 
 * \param [in] in_uid 
 * \param [in] in_key 
 * \param [in] in_data 
 * \param [in] in_model_context 
 */
sse_int
Led_startBlink(Moat in_moat, sse_char* in_uid, sse_char* in_key, MoatValue* in_data, sse_pointer in_model_context) {
  APP_LOG_DEBUG("*** Led_startBlink");
  system("led -m blink -n 1");
  return SSE_E_OK;
}

sse_bool 
TBlinkRgxLedApp_Initialize(TBlinkRgxLedApp* self, sse_char* in_urn) {
  ModelMapper mapper;
  sse_int ecode;

  ecode = moat_init(in_urn, &self->fMoat);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("moat_init");
    goto error_exit_0;
  }

  sse_memset(&mapper, 0, sizeof(mapper));
  ecode = moat_register_model(self->fMoat, MOAT_MODEL_LED, &mapper, self);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("moat_register_model");
    goto error_exit_1;
  }

  return sse_true;

 error_exit_1:
  moat_destroy(self->fMoat);
 error_exit_0:

  return sse_false;
}

void 
TBlinkRgxLedApp_Finalize(TBlinkRgxLedApp* self) {
  moat_remove_model(self->fMoat, MOAT_MODEL_LED);
  moat_destroy(self->fMoat);
}

sse_int 
TBlinkRgxLedApp_Start(TBlinkRgxLedApp* self) {
  moat_run(self->fMoat);
  return SSE_E_OK;
}

sse_int 
TBlinkRgxLedApp_Stop(TBlinkRgxLedApp* self) {
  moat_quit(self->fMoat);
  return SSE_E_OK;
}

sse_int
moat_app_main(sse_int in_argc, sse_char *argv[])
{
  TBlinkRgxLedApp app;
  sse_bool bcode;
  sse_int ecode;

  APP_LOG_OPEN();

  bcode = TBlinkRgxLedApp_Initialize(&app, argv[0]);
  if (bcode == sse_false) {
    APP_LOG_ERROR("TBlinkRgxLedApp_Initialize failed");
    return SSE_E_GENERIC;
  }
  
  ecode = TBlinkRgxLedApp_Start(&app);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("TBlinkRgxLedApp_Start failed");
    TBlinkRgxLedApp_Finalize(&app);
    return ecode;
  }

  TBlinkRgxLedApp_Finalize(&app);

  APP_LOG_CLOSE();

  return SSE_E_OK;
}
