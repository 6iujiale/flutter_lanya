import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_lanaya/model/blue_info.dart';
import 'package:provider/provider.dart';

import 'blue_service.dart';

class BlueConnectProvider with ChangeNotifier {
  BluetoothDevice? _device;
  StreamSubscription<BluetoothConnectionState>? subscription;
  BuildContext? _context;
  late BlueInfoModel deviceInfo;
  String connectMsg = "";

  Future<void> setDevices(
      BluetoothDevice newDevice, int connectMode, BuildContext context) async {
    if (_device != null) {
      await disconnectDevice(); // 如果有新设备添加进来，断开当前设备
    }
    _device = newDevice;
    _context = context;
    deviceInfo = BlueInfoModel(
      remoteId: _device!.remoteId,
      advName: _device!.advName.isEmpty ? "未命名" : _device!.advName,
      connectMode: connectMode,
    );
    print('blue_connect_deviceInfo：${deviceInfo.toString()}');

    notifyListeners();
  }

  Future<void> startBlueConnect(int mode) async {
    print("Starting connection with mode: $mode");
    if (_device == null) return;
    if (mode == 0) {
      await _device!
          .connect(autoConnect: false, timeout: const Duration(seconds: 5));
    } else {
      await _device!.connect(
          autoConnect: true, timeout: const Duration(seconds: 5), mtu: null);
      //BluetoothConnectionState.connected 时捕获该事件,将等待直到设备的连接状态变为已连接。
      await _device!.connectionState
          .where((val) => val == BluetoothConnectionState.connected)
          .first;
    }
  }

  Future<void> connectDevice() async {
    if (_device == null) return;
    print("正在连接${_device!.remoteId}设备");
    try {
      int? mode = deviceInfo.connectMode;
      await startBlueConnect(mode!); // 确保正确等待连接操作完成
    } on FlutterBluePlusException catch (e) {
      deviceInfo.isConnect = false;
      connectMsg = e.toString();
    } finally {
      await setConnectionStateListener();
      print("连接操作已完成");
    }
  }

  Future<void> disconnectDevice() async {
    if (_device == null) return;
    try {
      await _device!.disconnect();
    } catch (e) {
      print('捕获到FlutterBluePlusException异常: ${e.toString()}');
    } finally {
      await setConnectionStateListener();
      cancelSubscription();
      // connectMsg = "断开操作已完成";
      /* if (deviceInfo.isConnect == false) {
        connectMsg = "${_device!.remoteId}断开成功";
      }*/
      notifyListeners();
    }
  }

  Future<void> setConnectionStateListener() async {
    if (_device == null) return;
    print("----------正在检查：${_device!.remoteId}--------");
    cancelSubscription(); // 先取消订阅
    subscription = _device!.connectionState.listen((state) {
      print("哈哈哈哈${state}");
      if (state == BluetoothConnectionState.connected) {
        print("----------已连接：${_device!.remoteId}--------");
        connectMsg = "已连接：${_device!.remoteId}";
        deviceInfo.isConnect = true;
        notifyListeners();
        Provider.of<BlueServicesProvider>(_context!, listen: false)
            .getServices(_device!, _context!);
      } else if (state == BluetoothConnectionState.disconnected) {
        print("----------断开：${_device!.remoteId}--------");
        connectMsg = "断开设备：${_device!.remoteId}";
        deviceInfo.isConnect = false;
        Provider.of<BlueServicesProvider>(_context!, listen: false)
            .logBuffer
            .clear();
        notifyListeners();
      }
    });
    _device!.cancelWhenDisconnected(subscription!, delayed: true);
  }

  void cancelSubscription() {
    subscription?.cancel();
    subscription = null;
  }
}
