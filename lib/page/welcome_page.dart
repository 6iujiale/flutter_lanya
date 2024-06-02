import 'package:flutter/material.dart';
import 'package:flutter_lanaya/service/blue_permission_service.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  StringBuffer logBuffer = StringBuffer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              logBuffer.isNotEmpty ? logBuffer.toString() : "初始化中....",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/blueScan");
              },
              child: const Text("扫描"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initApp() async {
    logBuffer.clear();
    bool flag = await BluePermissionService().checkBlueSupport();
    //Bluetooth supported by this device  指设备硬件不支持蓝牙，即根本就没有蓝牙模块或驱动
    if (!flag) {
      _writeToBuffer("Bluetooth not supported by this device\n");
      return;
    }
    _writeToBuffer("Bluetooth supported by this device\n");
    await BluePermissionService().turnOnBlue();
    List<String> list = await BluePermissionService().checkPermission();
    list.isNotEmpty
        ? _writeToBuffer("权限：${list.toString()}未授权\n")
        : _writeToBuffer("权限全已授权\n");
  }

  void _writeToBuffer(String msg) {
    setState(() {
      logBuffer.write(msg);
    });
  }
}
