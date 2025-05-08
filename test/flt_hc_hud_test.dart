import 'package:flutter_test/flutter_test.dart';
import 'package:flt_hc_hud/flt_hc_hud.dart';
import 'package:flt_hc_hud/flt_hc_hud_platform_interface.dart';
import 'package:flt_hc_hud/flt_hc_hud_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFltHcHudPlatform
    with MockPlatformInterfaceMixin
    implements FltHcHudPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FltHcHudPlatform initialPlatform = FltHcHudPlatform.instance;

  test('$MethodChannelFltHcHud is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFltHcHud>());
  });

  test('getPlatformVersion', () async {
    FltHcHud fltHcHudPlugin = FltHcHud();
    MockFltHcHudPlatform fakePlatform = MockFltHcHudPlatform();
    FltHcHudPlatform.instance = fakePlatform;

    expect(await fltHcHudPlugin.getPlatformVersion(), '42');
  });
}
