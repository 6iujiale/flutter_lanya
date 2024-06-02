import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_lanaya/model/blue_characteristic.dart';
import 'package:flutter_lanaya/service/blue_log_call_back.dart';
import 'package:provider/provider.dart';

import '../model/blue_info.dart';
import '../widget/logger.dart';
import 'blue_connect.dart';

class BlueServicesProvider with ChangeNotifier implements BlueLogCallBack {
  late BlueConnectProvider provider;
  late BlueInfoModel deviceInfo;
  BluetoothCharacteristic? _characteristic;
  int? _deviceMtuNow;
  StreamSubscription<List<int>>? _subscription;
  final StringBuffer _logBuffer = StringBuffer();

  StringBuffer get logBuffer => _logBuffer;

  Future<void> getServices(BluetoothDevice device, BuildContext context) async {
    addLog("--------------正在获取蓝牙服务-------------");
    provider = Provider.of<BlueConnectProvider>(context, listen: false);
    deviceInfo = provider.deviceInfo;
    List<CharacteristicList> characteristicsList = [];
    List<BluetoothService> services = await device.discoverServices();
    _deviceMtuNow = device.mtuNow;
    for (BluetoothService service in services) {
      CharacteristicList characteristicList = CharacteristicList(
        serviceUuid: service.uuid,
        characteristics: [],
      );
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        Map<String, bool> permissionMap = {};
        void addPermissionMap(bool action, String permissionName) {
          if (action) {
            permissionMap[permissionName] = true;
          }
        }

        addPermissionMap(characteristic.properties.read, "read");
        addPermissionMap(characteristic.properties.writeWithoutResponse,
            "writeWithoutResponse");
        addPermissionMap(characteristic.properties.write, "write");
        addPermissionMap(characteristic.properties.notify, "notify");
        List<Descriptors> descriptors = await _getDescriptors(characteristic);
        Characteristics characteristics = Characteristics(
          characteristicUuid: characteristic.uuid,
          properties: permissionMap,
          descriptors: descriptors,
        );
        addLog("服务信息：${characteristics.toString()}");
        characteristicList.characteristics!.add(characteristics);
      }
      characteristicsList.add(characteristicList);
    }
    deviceInfo.characteristicList = characteristicsList;
    logUtil().debug(deviceInfo.toJson());
    // addLog("设备信息：${deviceInfo.toJson()}");
    notifyListeners();
  }

  Future<List<Descriptors>> _getDescriptors(
      BluetoothCharacteristic characteristic) async {
    List<Descriptors> descriptors = [];
    for (BluetoothDescriptor descriptor in characteristic.descriptors) {
      Descriptors desc = Descriptors(
        descriptorUuid: descriptor.uuid,
        lastValue: descriptor.lastValue,
      );
      descriptors.add(desc);
    }
    return descriptors;
  }

  void setCharacteristics(BlueCharacteristicModel model) {
    _characteristic = BluetoothCharacteristic(
      remoteId: model.remoteId,
      serviceUuid: model.serviceUuid,
      characteristicUuid: model.characteristicUuid,
    );
    print("特征数据：$_characteristic");
    // addLog("特征数据：$_characteristic");
  }

  Future<void> readCharacteristics() async {
    addLog(
        "-------------------${_characteristic!.characteristicUuid}读数据----------------");
    try {
      List<int> value = await _characteristic!.read();
      String response = String.fromCharCodes(value);
      // addLog("读取值：$response");
      response.isEmpty ? addLog("暂无可读取的数据") : addLog("读取值：$response");
      // print("读取值：$response");
    } catch (e) {
      addLog("读取错误：${e.toString()}");
      // print("读取错误：${e.toString()}");
    } finally {
      notifyListeners();
      // await notifyCharacteristics();
    }
  }

  Future<void> writeCharacteristics(String data) async {
    addLog(
        "-------------------${_characteristic!.characteristicUuid}写数据----------------");
    List<int> randomBytes = _getRandomBytes(data);
    if (randomBytes.isEmpty) return;
    bool withoutResponse = _shouldWriteWithoutResponse();
    try {
      if (randomBytes.length >= 100) {
        // print("写入大量数据：$randomBytes, withoutResponse: $withoutResponse");
        addLog("写入大量数据：$randomBytes");
        await _splitWrite(randomBytes);
      } else {
        // print("写入少量数据：$randomBytes, withoutResponse: $withoutResponse");
        addLog("写入少量数据：$randomBytes");
        await _characteristic!
            .write(randomBytes, withoutResponse: withoutResponse);
      }
    } catch (e) {
      // print("写入错误：${e.toString()}");
      addLog("写入错误：${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> notifyCharacteristics() async {
    // print("------------通知------------");
    addLog(
        "----------------------${_characteristic!.characteristicUuid}通知---------------------");
    if (_characteristic == null) {
      print("通知错误：characteristic为空");
      return;
    }
    try {
      // 取消之前的订阅
      await _subscription?.cancel();
      // 订阅新值
      _subscription = _characteristic!.value.listen((value) {
        // print("通知：$value");
        addLog("通知：$value");
      });
      // 启用通知
      await _characteristic!.setNotifyValue(true);
    } catch (e) {
      // print("启动通知监听错误：${e.toString()}");
      addLog("启动通知监听错误：${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _splitWrite(List<int> value, {int timeout = 15}) async {
    int chunkSize = _deviceMtuNow! - 3; // 3 bytes BLE overhead
    for (int i = 0; i < value.length; i += chunkSize) {
      List<int> chunk = value.sublist(i, min(i + chunkSize, value.length));
      await _characteristic!
          .write(chunk, withoutResponse: false, timeout: timeout);
    }
  }

  List<int> _getRandomBytes(String data) {
    return utf8.encode(data);
  }

  bool _shouldWriteWithoutResponse() {
    if (_characteristic == null) return false;
    addLog("找到特定设备HLK");
    String characteristicUuid = _characteristic!.characteristicUuid.toString();
    // 检测特定的UUID，因为某些蓝牙模块的机制问题, withoutResponse必须为true
    return characteristicUuid == "fff2" || characteristicUuid == "fff3";
  }

  @override
  void addLog(String msg) {
    // TODO: implement addLog
    _logBuffer.writeln(msg);
  }
}
