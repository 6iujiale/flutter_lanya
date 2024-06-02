import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_lanaya/model/blue_example.dart';
import 'package:flutter_lanaya/widget/logger.dart';

class BlueScanProvider with ChangeNotifier {
  List<Map> devicesList = [];
  BluetoothDevice? autoDevice;
  String scanErrorMsg = "";
  StreamSubscription<List<ScanResult>>? subscription;
  final int _scanSeconds = 6;
  BlueExampleModel? exampleModel;
  bool _deviceFound = false;
  Completer<BluetoothDevice?>? _completer;

  // 扫描模式
  int getScanMode() {
    return (exampleModel == null || exampleModel!.remoteId.isEmpty) ? 0 : 1;
  }

  // 初始化扫描
  Future<void> startBlueScan(int statusCode) async {
    await FlutterBluePlus.stopScan(); // 确保上一次扫描已经停止
    switch (statusCode) {
      case 0:
        print("--------多设备扫描--------");
        await FlutterBluePlus.startScan(
          timeout: Duration(seconds: _scanSeconds),
          androidUsesFineLocation: true,
        );
        break;
      case 1:
        if (exampleModel != null) {
          print("--------单设备扫描--------\n${exampleModel.toString()}");
          await FlutterBluePlus.startScan(
            withServices: [Guid(exampleModel!.uuid)],
            withNames: [exampleModel!.advName],
            timeout: Duration(seconds: _scanSeconds),
          );
        }
        break;
    }
  }

  // 开始扫描
  Future<BluetoothDevice?> getDevices() async {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(null); // 如果上一个扫描未完成，则取消它
    }
    _completer = Completer<BluetoothDevice?>();
    _deviceFound = false;
    // devicesList.clear();
    try {
      int statusCode = getScanMode();
      await startBlueScan(statusCode);

      // 监听扫描结果
      subscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          handleScanResults(results, statusCode);
        },
        onError: (e) {
          scanErrorMsg = e.toString();
          print("blue-scan-error1: $scanErrorMsg");
          _completeWithError(e);
        },
        onDone: () {
          if (!_deviceFound) {
            _completeWithDevice();
          }
        },
      );

      // 扫描结束后停止扫描
      Future.delayed(Duration(seconds: _scanSeconds)).then((_) {
        stopScan().then((_) {
          _completeWithDevice();
        });
      });
    } catch (e) {
      print("blue-scan-error2: $e");
      scanErrorMsg = e.toString();
      _completeWithError(e);
    }

    return _completer!.future;
  }

  void _completeWithDevice() {
    if (!_completer!.isCompleted) {
      _completer!.complete(_deviceFound ? autoDevice : null);
    }
  }

  void _completeWithError(Object error) {
    if (!_completer!.isCompleted) {
      _completer!.completeError(error);
    }
  }

  // 停止扫描
  Future<void> stopScan() async {
    print("-------停止扫描---------");
    await FlutterBluePlus.stopScan();
    subscription?.cancel();
    clearExampleModel();
    notifyListeners();
  }

  // 处理扫描结果
  void handleScanResults(List<ScanResult> results, int statusCode) async {
    print("处理扫描结果：$statusCode, remoteID：${exampleModel?.remoteId}");
    for (var result in results) {
      var device = {
        "blue": result.device,
        "remoteId": result.device.remoteId.str,
        "advName": result.advertisementData.advName,
        "rssi": result.rssi, //信号强度
      };
/*      logUtil().debug(result.toString());*/
      if (!devicesList.any((d) => d['remoteId'] == device['remoteId']) &&result.advertisementData.connectable) {
        devicesList.add(device);
        // logUtil().debug(result.toString());
        notifyListeners();
      }
      if (statusCode == 1 && device['remoteId'] == exampleModel?.remoteId) {
        print('${exampleModel?.remoteId} with service found!');
        autoDevice = result.device;
        _deviceFound = true;
        _completeWithDevice();
        notifyListeners();
        break;
      }
    }
  }

  // 清空 exampleModel
  void clearExampleModel() {
    exampleModel = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
