import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flt_hc_hud_method_channel.dart';

abstract class FltHcHudPlatform extends PlatformInterface {
  /// Constructs a FltHcHudPlatform.
  FltHcHudPlatform() : super(token: _token);

  static final Object _token = Object();

  static FltHcHudPlatform _instance = MethodChannelFltHcHud();

  /// The default instance of [FltHcHudPlatform] to use.
  ///
  /// Defaults to [MethodChannelFltHcHud].
  static FltHcHudPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FltHcHudPlatform] when
  /// they register themselves.
  static set instance(FltHcHudPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
