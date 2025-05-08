#ifndef FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_
#define FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _FltHcHudPlugin FltHcHudPlugin;
typedef struct {
  GObjectClass parent_class;
} FltHcHudPluginClass;

FLUTTER_PLUGIN_EXPORT GType flt_hc_hud_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void flt_hc_hud_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_
