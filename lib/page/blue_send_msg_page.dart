import 'package:flutter/material.dart';
import 'package:flutter_lanaya/provider/blue_service.dart';
import 'package:flutter_lanaya/widget/logger.dart';
import 'package:flutter_lanaya/widget/toast_custom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/blue_characteristic.dart';

class BlueSendMessagePage extends StatefulWidget {
  final double height;
  final BlueCharacteristicModel model;

  const BlueSendMessagePage(
      {super.key, required this.height, required this.model});

  @override
  State<BlueSendMessagePage> createState() => _BlueSendMessagePageState();
}

class _BlueSendMessagePageState extends State<BlueSendMessagePage> {
  late TextEditingController _textController;
  late BlueServicesProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
    // Provider.of<BlueServicesProvider>(context, listen: false).notifyCharacteristics();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child:
          Consumer<BlueServicesProvider>(builder: (context, provider, child) {
        provider.setCharacteristics(widget.model);
        return ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textController,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入发送的指令',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onEditingComplete: () {
                  logUtil().debug(_textController.text);
                },
              ),
            ),
           /* ListTile(
              onTap: () async {
                await provider.readCharacteristics();
              },
              title: const Text("读数据"),
            ),*/
            ListTile(
              onTap: () async {
                String data = _textController.text;
                data.isNotEmpty
                    ? await provider.writeCharacteristics(data)
                    // : MyCustomToast().showShortToast("数据为空，输入框请写入数据");
                    : MyCustomToast(msg: '数据为空，输入框请写入数据').showShortToast();
              },
              title: const Text("写数据"),
            ),
            /* ListTile(
              onTap: () async {
                await provider.notifyCharacteristics();
              },
              title: const Text("接收通知"),
            ),*/
          ],
        );
      }),
    );
  }
}
