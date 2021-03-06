#include <servicesync/moat.h>
#include <ev.h>
#include "rgx-sysinfo-debug.h"
#include "sysinfo.h"

sse_int
moat_app_main(sse_int in_argc, sse_char* argv[]) {
  TSysInfoUploader app;
  sse_bool bcode;
  sse_int ecode;

  APP_LOG_OPEN();

  bcode = TSysInfoUploader_Initialize(&app, argv[0]);
  if (bcode == sse_false) {
    APP_LOG_ERROR("TSysInfoUploader_Initialize failed");
    return SSE_E_GENERIC;
  }

  ecode = TSysInfoUploader_Run(&app);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("TSysInfoUploader_Run failed");
    TSysInfoUploader_Finalize(&app);
    return ecode;
  }

  TSysInfoUploader_Finalize(&app);

  APP_LOG_CLOSE();

  return SSE_E_OK;
}

