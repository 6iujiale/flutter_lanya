import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_lanaya/config/blue_example_config.dart';
import 'package:flutter_lanaya/model/blue_example.dart';
import 'package:flutter_lanaya/provider/blue_connect.dart';
import 'package:flutter_lanaya/provider/blue_scan.dart';
import 'package:flutter_lanaya/widget/cached_network_image.dart';
import 'package:flutter_lanaya/widget/toast_custom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';

class BlueDevicesExamplePage extends StatefulWidget {
  const BlueDevicesExamplePage({super.key});

  @override
  State<BlueDevicesExamplePage> createState() => _BlueDevicesExamplePageState();
}

class _BlueDevicesExamplePageState extends State<BlueDevicesExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfig.appBarTitle["blueDevicesExample"]}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("添加设备");
          setState(() {
            /* BlueExampleConfig.devicesList.add(
              {
                "blueImage":
                "https://www.motorobit.com/hlk-b35-serial-wifibluetooth-50-gelistirme-kiti-wifi-hi-link-57433-44-B.jpg",
                "blueAdvName": "HLK-BLE_2FBF",
                "blueRemoteId": "B4:C2:E0:C7:2F:C0",
                "blueUUID": "0000fff0-0000-103
                00-8000-00805f9b34fb"
              },
            );*/
          });
        },
        child: const Icon(Icons.add),
      ),
      body: const Column(
        children: [
          Expanded(
            child: DevicesCard(),
          ),
        ],
      ),
    );
  }
}

class DevicesCard extends StatefulWidget {
  const DevicesCard({super.key});

  @override
  _DevicesCardState createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  late BlueScanProvider scanProvider;
  late BlueConnectProvider connectProvider;
  late List<Map> devicesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scanProvider = Provider.of<BlueScanProvider>(context, listen: false);
    connectProvider = Provider.of<BlueConnectProvider>(context, listen: false);
    devicesList = BlueExampleConfig.devicesList;
  }

  @override
  void dispose() {
    super.dispose();
    scanProvider.stopScan();
  }

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () async {
        scanProvider.exampleModel = BlueExampleModel(
            advName: item['blueAdvName'],
            remoteId: item['blueRemoteId'],
            uuid: item['blueUUID']);
        BluetoothDevice? device = await scanProvider.getDevices();
        print("blue-example-page：$device");
        if (device != null) {
          Get.toNamed(
            "/blueAutoConnect",
          );
          connectProvider.setDevices(
            device,
            // ignore: use_build_context_synchronously
            AppConfig.appEvenCode['connectEven']!['blueAutoConnect']!, context,
          );
        } else {
          // print("blue-example-page：No device found");
          // aMyCustomToast().showLongToast("blue-example-page：No device found");
          MyCustomToast(
              msg: 'blue-example-page：No device found', loadingTime: 1);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180.h,
              width: double.infinity, //最大宽度
              //图片加载、缓存组件
              child: CustomNetworkImageWidget(
                imageUrl: item['blueImage'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item['blueRemoteId']}",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item['blueAdvName']}",
                        style: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            devicesList.remove(item);
                          });
                          print("点击了设备删除按钮");
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.pink,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.86,
      ),
      itemCount: devicesList.length,
      itemBuilder: (context, index) {
        return _gridViewItem(context, devicesList[index]);
      },
    );
  }
}
