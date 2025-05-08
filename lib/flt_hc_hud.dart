export 'package:flt_hc_hud/hud/hc_hud.dart';
import 'flt_hc_hud_platform_interface.dart';

class FltHcHud {
  Future<String?> getPlatformVersion() {
    return FltHcHudPlatform.instance.getPlatformVersion();
  }
}
