import 'package:flutter/material.dart';
import 'package:flutter_lanaya/provider/blue_connect.dart';
import 'package:flutter_lanaya/widget/toast_custom.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BlueConnectPage extends StatelessWidget {
  final double height;

  const BlueConnectPage({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Consumer<BlueConnectProvider>(
        builder: (context, provider, child) {
          return ProgressHUD(
            child: Builder(
              builder: (context) {
                var progress = ProgressHUD.of(context);
                return ListView(
                  children: <Widget>[
                    ListTile(
                      title: const Text("连接设备"),
                      onTap: () async {
                        try {
                          progress?.showWithText('Loading...');
                          await provider.connectDevice();
                          await MyCustomToast(
                                  // msg: provider.logBuffer.toString())
                                  msg: provider.connectMsg)
                              .showShortToast();
                        } catch (e) {
                          // Handle error
                        } finally {
                          progress?.dismiss();
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        '设备：${provider.deviceInfo.advName}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        '当前状态：${provider.deviceInfo.isConnect == true ? '已连接' : '断开'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (provider.deviceInfo.isConnect == true)
                      ListTile(
                        title: const Text("查看服务列表"),
                        onTap: () {
                          Get.toNamed("/blueServices", arguments: {
                            "title": provider.deviceInfo.advName
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
