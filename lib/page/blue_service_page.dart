import 'package:flutter/material.dart';
import 'package:flutter_lanaya/model/blue_characteristic.dart';
import 'package:flutter_lanaya/model/blue_info.dart';
import 'package:flutter_lanaya/page/blue_send_msg_page.dart';
import 'package:flutter_lanaya/page/blue_service_msg.dart';
import 'package:flutter_lanaya/provider/blue_connect.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../model/expand_state_model.dart';
import '../provider/blue_service.dart';
import '../widget/logger.dart';
import '../widget/toast_custom.dart';

class BlueServicesPage extends StatefulWidget {
  const BlueServicesPage({super.key});

  @override
  State<BlueServicesPage> createState() => _BlueServicesPageState();
}

class _BlueServicesPageState extends State<BlueServicesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late BlueConnectProvider connectProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    connectProvider = Provider.of<BlueConnectProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _tabController.dispose(); // 释放内存
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("${AppConfig.appBarTitle['blueServicesPage']}"),
        title: Text("${Get.arguments['title']}"),
        actions: [
          TextButton(
            onPressed: () async {
              // Get.back();
              await connectProvider.disconnectDevice();
              await MyCustomToast(
                      msg: connectProvider.connectMsg, loadingTime: 2)
                  .showShortToast();
              Get.back();
            },
            child: const Text("断开"),
          ),
        ],
      ),
      body: const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: "蓝牙服务",
                      ),
                      Tab(
                        text: "操作日志",
                      ),
                    ],
                  ),
                  Flexible(
                    child: TabBarView(
                      children: [
                        ServiceComments(),
                        BlueServiceMsg(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ServiceComments extends StatefulWidget {
  const ServiceComments({super.key});

  @override
  State<ServiceComments> createState() => _ServiceCommentsState();
}

//混入AutomaticKeepAliveClientMixin保持页面状态
class _ServiceCommentsState extends State<ServiceComments>
    with AutomaticKeepAliveClientMixin {
  List<ExpandStateBean> expandStateList = [];
  late BlueServicesProvider provider;
  late BlueInfoModel device;
  late List<dynamic> modelData;
  bool iconClicked = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BlueServicesProvider>(context, listen: false);
    device = provider.deviceInfo;
  }

  _setCurrentIndex(int index) {
    setState(() {
      for (var item in expandStateList) {
        if (item.index == index) {
          item.isOpen = !item.isOpen;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<BlueServicesProvider>(
      builder:
          (BuildContext context, BlueServicesProvider provider, Widget? child) {
        List<dynamic>? characteristicList = device.characteristicList;
        if (expandStateList.isEmpty) {
          expandStateList = List.generate(characteristicList!.length,
              (index) => ExpandStateBean(index: index));
        }
        return SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              _setCurrentIndex(index);
              modelData = characteristicList[index].characteristics;
              logUtil().debug(
                  "传递modelData数据${characteristicList[index].serviceUuid},信息${characteristicList[index].characteristics.toString()}");
            },
            children: List.generate(characteristicList!.length, (index) {
              return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      characteristicList[index]
                          .serviceUuid
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: characteristicList[index].characteristics!.length,
                  itemBuilder: (context, idx) {
                    var characteristics =
                        characteristicList[index].characteristics![idx];
                    Map propertiesMap = characteristics.properties;
                    String permissionMsg = propertiesMap.keys.join(",");
                    var isShowBottomSheet = false;
                    return ListTile(
                      title: Text(
                        characteristics.characteristicUuid
                            .toString()
                            .toUpperCase(),
                      ),
                      subtitle: Text(
                        permissionMsg.isEmpty ? "无可用权限" : permissionMsg,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 10.0, // Add spacing between icons
                        children: [
                          if (propertiesMap.containsKey('notify'))
                            InkWell(
                              onTap: () async {
                                provider.setCharacteristics(
                                  BlueCharacteristicModel(
                                    remoteId: device.remoteId,
                                    serviceUuid:
                                        characteristicList[index].serviceUuid,
                                    characteristicUuid:
                                        characteristics.characteristicUuid,
                                  ),
                                );
                                await provider.notifyCharacteristics();
                                isShowBottomSheet = true;
                              },
                              child: const Icon(
                                Icons.notifications_active_sharp,
                                color: Colors.pink,
                                size: 35,
                              ),
                            ),
                          if (propertiesMap.containsKey("read"))
                            InkWell(
                              onTap: () async {
                                provider.setCharacteristics(
                                  BlueCharacteristicModel(
                                    remoteId: device.remoteId,
                                    serviceUuid:
                                        characteristicList[index].serviceUuid,
                                    characteristicUuid:
                                        characteristics.characteristicUuid,
                                  ),
                                );
                                await provider.readCharacteristics();
                                isShowBottomSheet = true;
                              },
                              child: const Icon(
                                Icons.download,
                                color: Colors.pink,
                                size: 35,
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        if (propertiesMap.containsKey('write') &&
                            propertiesMap.isNotEmpty) {
                          bottomSheet(context, characteristicList, index,
                              characteristics);
                        }
                      },
                    );
                  },
                ),
                isExpanded: expandStateList[index].isOpen,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void bottomSheet(BuildContext context, List<dynamic> characteristicList,
      int index, characteristics) {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => BlueSendMessagePage(
        height: 300,
        model: BlueCharacteristicModel(
          remoteId: device.remoteId,
          serviceUuid: characteristicList[index].serviceUuid,
          characteristicUuid: characteristics.characteristicUuid,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
