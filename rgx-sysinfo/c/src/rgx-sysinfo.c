#include <servicesync/moat.h>
#include <stdlib.h>
#include <string.h>
#include <ev.h>
#include <uuid/uuid.h>
#include <linux/kernel.h>
#include <sys/sysinfo.h>
#include "rgx-sysinfo-debug.h"

#define MOAT_JOB_SERVICE_ID ("upload")
#define MOAT_URN_PREFIX ("urn:moat:")
#define MOAT_URN_SUFFIX (":1.0")
#define MOAT_MODEL_NAME ("SysInfo")
#define UPLOAD_TIMER_INTERVAL (60)

typedef struct TSysInfoUploader_ TSysInfoUploader;
struct TSysInfoUploader_ {
  Moat fMoat;
  MoatObject* fObjects;
  sse_char* fServiceId;
  ev_periodic fUploadTimer;
};

static sse_int
SysInfoUploader_MakeServiceId(sse_char* in_urn, sse_char* in_service_name, sse_char** out_service_id) {
  sse_uint prefix_len;
  sse_uint suffix_len;
  sse_uint urn_len;
  sse_uint service_len;
  sse_char *service_id;
  sse_char *p;

  prefix_len = sse_strlen(MOAT_URN_PREFIX);
  urn_len = sse_strlen(in_urn);
  service_len = sse_strlen(in_service_name);
  suffix_len = sse_strlen(MOAT_URN_SUFFIX);
  service_id = sse_malloc(prefix_len + urn_len + 1 + service_len + suffix_len + 1);
  if (service_id == NULL) {
    return SSE_E_NOMEM;
  }
  p = service_id;
  sse_memcpy(p, MOAT_URN_PREFIX, prefix_len);
  p += prefix_len;
  sse_memcpy(p, in_urn, urn_len);
  p += urn_len;
  *p = ':';
  p++;
  sse_memcpy(p, in_service_name, service_len);
  p += service_len;
  sse_memcpy(p, MOAT_URN_SUFFIX, suffix_len);
  p += suffix_len;
  *p = '\0';

  *out_service_id = service_id;

  return SSE_E_OK;
}

static void
SysInfoUploader_TimerCallback(struct ev_loop* loop, ev_periodic* w, int revents) {
  TSysInfoUploader* self;
  MoatObject* obj;
  uuid_t uuid_hex;
  sse_char uuid[36 + 1];
  struct sysinfo info;

  APP_LOG_DEBUG("*** Upload timer expired");

  self = (TSysInfoUploader*)w->data;

  memset(&info, 0, sizeof(info));
  sysinfo(&info);
  APP_LOG_DEBUG("totalMem=[%ld] freeMem=[%ld] procs=[%u]", info.totalram, info.freeram, info.procs);

  obj = moat_object_new();
  moat_object_add_int64_value(obj, "totalMem", info.totalram, sse_true);
  moat_object_add_int64_value(obj, "freeMem", info.freeram, sse_true);
  moat_object_add_int32_value(obj, "procs", info.procs, sse_true);

  sse_memset(uuid, 0, sizeof(uuid));
  uuid_generate_random(uuid_hex);
  uuid_unparse(uuid_hex, uuid);
  moat_object_add_object_value(self->fObjects, uuid, obj, sse_false, sse_true);
  
  APP_LOG_DEBUG("moat_send_notification done: len=%d", moat_object_get_length(self->fObjects));
  moat_send_notification(self->fMoat, self->fServiceId, NULL, MOAT_MODEL_NAME, self->fObjects, NULL, NULL);
  moat_object_remove_all(self->fObjects);
}

static sse_bool 
TSysInfoUploader_Initialize(TSysInfoUploader* self, sse_char* in_urn) {
  ModelMapper mapper;
  sse_char* service_id;
  sse_int ecode;

  ecode = moat_init(in_urn, &self->fMoat);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("moat_init");
    goto error_exit_0;
  }

  sse_memset(&mapper, 0, sizeof(mapper));
  ecode = moat_register_model(self->fMoat, MOAT_MODEL_NAME, &mapper, self);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("moat_register_model");
    goto error_exit_1;
  }

  ecode = SysInfoUploader_MakeServiceId(in_urn, MOAT_JOB_SERVICE_ID, &service_id);
  if (ecode != SSE_E_OK) {
    APP_LOG_ERROR("SysInfoUploader_MakeServiceId");
    goto error_exit_2;
  }
  APP_LOG_DEBUG("Service ID=%s", service_id);

  self->fObjects = moat_object_new();
  if (self->fObjects == NULL) {
    APP_LOG_ERROR("moat_object_new");
    goto error_exit_3;
  }

  self->fServiceId = service_id;

  return sse_true;

 error_exit_3:
  sse_free(service_id);
 error_exit_2:
  moat_remove_model(self->fMoat, MOAT_MODEL_NAME);
 error_exit_1:
  moat_destroy(self->fMoat);
 error_exit_0:

  return sse_false;
}

static void 
TSysInfoUploader_Finalize(TSysInfoUploader* self) {
  moat_object_remove_all(self->fObjects);
  moat_object_free(self->fObjects);
  sse_free(self->fServiceId);
  moat_remove_model(self->fMoat, MOAT_MODEL_NAME);
  moat_destroy(self->fMoat);
}

static sse_int
TSysInfoUploader_Run(TSysInfoUploader* self) {
  struct ev_loop* loop;

  loop = ev_default_loop(0);
  ev_periodic_init(&self->fUploadTimer, SysInfoUploader_TimerCallback, 0, (ev_tstamp)UPLOAD_TIMER_INTERVAL, 0);
  ev_periodic_start(loop, &self->fUploadTimer);
  self->fUploadTimer.data = self;

  moat_run(self->fMoat);

  return SSE_E_OK;
}
static sse_int
TSysInfoUploader_Quit(TSysInfoUploader* self) {
  moat_quit(self->fMoat);
  return SSE_E_OK;
}

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
