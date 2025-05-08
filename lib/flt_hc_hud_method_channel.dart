import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flt_hc_hud_platform_interface.dart';

/// An implementation of [FltHcHudPlatform] that uses method channels.
class MethodChannelFltHcHud extends FltHcHudPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flt_hc_hud');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
