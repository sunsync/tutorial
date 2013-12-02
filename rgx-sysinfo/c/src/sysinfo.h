#ifndef __SYSINFO_H__
#define __SYSINFO_H__

SSE_BEGIN_C_DECLS

typedef struct TSysInfoUploader_ TSysInfoUploader;
struct TSysInfoUploader_ {
  Moat fMoat;
  MoatObject* fObjects;
  sse_char* fServiceId;
  ev_periodic fUploadTimer;
};

sse_bool TSysInfoUploader_Initialize(TSysInfoUploader* self, sse_char* in_urn);
void TSysInfoUploader_Finalize(TSysInfoUploader* self);
sse_int TSysInfoUploader_Run(TSysInfoUploader* self);

sse_int TSysInfoUploader_Quit(TSysInfoUploader* self);

SSE_END_C_DECLS

#endif /* __SYSINFO_H__ */
