import 'package:flutter_lanaya/page/blue_auto_connect_page.dart';
import 'package:flutter_lanaya/page/blue_example_page.dart';
import 'package:flutter_lanaya/page/blue_scan_page.dart';
import 'package:flutter_lanaya/page/blue_service_page.dart';
import 'package:flutter_lanaya/page/welcome_page.dart';
import 'package:get/get.dart';

class AppPage {
  static final routes = [
    GetPage(
      name: "/blueScan",
      page: () => const BlueScanPage(),
    ),
    GetPage(
      name: "/welcome",
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: "/blueDevicesExample",
      page: () => const BlueDevicesExamplePage(),
    ),
    GetPage(
      name: "/blueAutoConnect",
      page: () => const BlueAutoConnectPage(),
    ),
    GetPage(
      name: "/blueServices",
      page: () => const BlueServicesPage(),
    ),
    /*GetPage(
      name: "/blueSendMsg",
      page: () => const BlueSendMessagePage(),
    ),*/
  ];
}
