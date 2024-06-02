import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lanaya/config/icons_config.dart';
import 'package:flutter_lanaya/page/blue_connect_page.dart';
import 'package:flutter_lanaya/provider/blue_connect.dart';
import 'package:flutter_lanaya/provider/blue_scan.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import '../widget/future_builder.dart';

class BlueScanPage extends StatefulWidget {
  const BlueScanPage({super.key});

  @override
  State<BlueScanPage> createState() => _BlueScanPageState();
}

class _BlueScanPageState extends State<BlueScanPage> {
  late BlueScanProvider scanProvider;
  late BlueConnectProvider connectProvider;
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    scanProvider = Provider.of<BlueScanProvider>(context, listen: false);
    connectProvider = Provider.of<BlueConnectProvider>(context, listen: false);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: false,
      controlFinishLoad: true,
    );
    _loadDevices();
  }

  @override
  void dispose() {
    scanProvider.stopScan();
    scanProvider.clearExampleModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppConfig.appBarTitle['blueScanPage']}"),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed("/blueDevicesExample");
            },
            icon: const Icon(
              AppIcons.devicesOther,
              color: Colors.pink,
              size: 25,
            ),
          ),
        ],
      ),
      body: EasyRefresh(
        controller: _refreshController,
        footer: const ClassicFooter(),
        onLoad: null,
        onRefresh: () async {
          _loadDevices();
        },
        child: Consumer<BlueScanProvider>(
          builder: (context, provider, child) {
            var list = provider.devicesList;
            if (list.isNotEmpty) {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final device = list[index];
                  return ListTile(
                    title: Text("${device["remoteId"]}"),
                    subtitle: Text(device["advName"]),
                    trailing: Text("${device['rssi']}"),
                    onTap: () {
                      connectProvider.setDevices(
                        device['blue'],
                        AppConfig.appEvenCode['connectEven']!['blueConnect']!,
                        context,
                      );
                      showMaterialModalBottomSheet(
                        context: context,
                        expand: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        builder: (context) =>
                            const BlueConnectPage(height: 370),
                      );
                    },
                  );
                },
              );
            } else {
              return CustomFutureBuilder.loading();
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadDevices() async {
    await scanProvider.getDevices();
  }
}
