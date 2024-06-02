import 'package:flutter/material.dart';
import 'package:flutter_lanaya/config/app_config.dart';
import 'package:flutter_lanaya/provider/blue_service.dart';
import 'package:flutter_lanaya/widget/future_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/blue_connect.dart';

class BlueAutoConnectPage extends StatefulWidget {
  const BlueAutoConnectPage({super.key});

  @override
  State<BlueAutoConnectPage> createState() => _BlueAutoConnectPageState();
}

class _BlueAutoConnectPageState extends State<BlueAutoConnectPage> {
  late BlueConnectProvider connectProvider;
  bool isConnecting = true;

  @override
  void initState() {
    super.initState();
    connectProvider = Provider.of<BlueConnectProvider>(context, listen: false);
    _initiateConnection();
  }

  Future<void> _initiateConnection() async {
    await connectProvider.connectDevice();
    setState(() {
      isConnecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppConfig.appBarTitle['blueAutoConnectPage']}"),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Consumer<BlueServicesProvider>(
            builder: (BuildContext context, BlueServicesProvider provider,
                Widget? child) {
              return isConnecting
                  ? CustomFutureBuilder.loading()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            // provider.logBuffer.toString(),
                            provider.deviceInfo.toString(),
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
