import 'package:flutter/material.dart';
import 'package:flutter_lanaya/config/app_config.dart';
import 'package:flutter_lanaya/provider/blue_service.dart';
import 'package:flutter_lanaya/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';

import '../provider/blue_connect.dart';
import '../provider/blue_devices_list.dart';
import '../provider/blue_scan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BlueScanProvider()),
        ChangeNotifierProvider(create: (_) => BlueConnectProvider()),
        ChangeNotifierProvider(create: (_) => BlueDevicesListProvider()),
        ChangeNotifierProvider(create: (_) => BlueServicesProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(AppConfig.appMaxWidth, AppConfig.appMaxHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: "dete_blue",
            debugShowCheckedModeBanner: false,
            // initialRoute: "/welcome",
            initialRoute: "/blueScan",
            // initialRoute: "/blueDevicesExample",
            getPages: AppPage.routes,
            theme: ThemeData(
              primarySwatch: Colors.pink,
            ),
          );
        },
      ),
    );
  }
}
