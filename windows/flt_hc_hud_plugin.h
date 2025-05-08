#ifndef FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_
#define FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flt_hc_hud {

class FltHcHudPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FltHcHudPlugin();

  virtual ~FltHcHudPlugin();

  // Disallow copy and assign.
  FltHcHudPlugin(const FltHcHudPlugin&) = delete;
  FltHcHudPlugin& operator=(const FltHcHudPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flt_hc_hud

#endif  // FLUTTER_PLUGIN_FLT_HC_HUD_PLUGIN_H_
