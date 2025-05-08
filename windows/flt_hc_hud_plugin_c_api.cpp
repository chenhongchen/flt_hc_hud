#include "include/flt_hc_hud/flt_hc_hud_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flt_hc_hud_plugin.h"

void FltHcHudPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flt_hc_hud::FltHcHudPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
