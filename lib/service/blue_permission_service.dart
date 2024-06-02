import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluePermissionService {
  Future<List<String>> checkPermission() async {
    Map<String, Permission> permissionMap = {
      "蓝牙": Permission.bluetooth,
      "蓝牙连接": Permission.bluetoothConnect,
      "蓝牙广播": Permission.bluetoothAdvertise,
      "蓝牙扫描": Permission.bluetoothScan,
      "位置": Permission.location,
    };
    List<String> unauthorizedPermissions = []; //未被授权的权限
    Map<Permission, PermissionStatus> status =
        await permissionMap.values.toList().request();
    //遍历权限集合条目，检查每个权限
    for (var entry in permissionMap.entries) {
      //未被授权，则打开系统应用设置界面
      if (status[entry.value] != PermissionStatus.granted) {
        unauthorizedPermissions.add(entry.key);
        openAppSettings();
      }
    }
    print("未开启的权限：${unauthorizedPermissions.toString()}");
    return unauthorizedPermissions;
  }

  Future<bool> checkBlueSupport() async {
    return FlutterBluePlus.isSupported;
  }

  Future<void> turnOnBlue() async {
    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {});
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
    subscription.cancel();
  }
}
