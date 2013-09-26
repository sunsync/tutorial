#ifndef __BLINK_RGX_LED_DEBUG_H__
#define __BLINK_RGX_LED_DEBUG_H__

#define APP_CONFIG_USE_SYSLOG

#ifdef APP_CONFIG_USE_SYSLOG
#include <syslog.h>
#define APP_LOG_OPEN() openlog("blink-rgx-led", LOG_PID, LOG_USER)
#define APP_LOG_CLOSE() closelog()
#define APP_LOG_PRINT(priority, format, ...) \
  syslog(priority, " %s:%s():L%d " format "\n", __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define APP_LOG_ERROR(format, ...) APP_LOG_PRINT(LOG_ERR, format, ##__VA_ARGS__)
#define APP_LOG_DEBUG(format, ...) APP_LOG_PRINT(LOG_DEBUG, format, ##__VA_ARGS__)
#else /* APP_CONFIG_USE_SYSLOG */
#define APP_LOG_OPEN()
#define APP_LOG_CLOSE()
#define APP_LOG_PRINT(type, tag, format, ...) \
  fprintf(stderr, "[" type "] <" tag "> %s:%s():L%d " format "\n", __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define APP_LOG_ERROR(format, ...) APP_LOG_PRINT("**ERROR**", "blink-rgx-led", format, ##__VA_ARGS__)
#define APP_LOG_DEBUG(format, ...) APP_LOG_PRINT("DEBUG", "blink-rgx-led", format, ##__VA_ARGS__)
#endif /* APP_CONFIG_USE_SYSLOG */

#endif /* __BLINK_RGX_LED_DEBUG_H__ */
