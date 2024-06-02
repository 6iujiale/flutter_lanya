import 'package:flutter/material.dart';
import 'package:flutter_lanaya/provider/blue_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BlueServiceMsg extends StatefulWidget {
  const BlueServiceMsg({super.key});

  @override
  State<BlueServiceMsg> createState() => _BlueServiceMsgState();
}

class _BlueServiceMsgState extends State<BlueServiceMsg>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlueServicesProvider>(
      builder:
          (BuildContext context, BlueServicesProvider provider, Widget? child) {
        var isClear = false;
        //使用column替换stack避免遮挡问题，让按钮永远位于页面的最底部
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    // provider.logBuffer.toString(),
                    isClear ? "" : provider.logBuffer.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.pink, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
            Container(
              height: 50, // Adjust height as needed
              color: Colors.white, // Background color for buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        provider.logBuffer.clear();
                        if (mounted) {
                          setState(() {
                            isClear = true;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.pink,
                        child: Text(
                          "清空",
                          style:
                              TextStyle(color: Colors.white, fontSize: 26.sp),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // handle tap
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.pink,
                        child: Text(
                          "导出",
                          style:
                              TextStyle(color: Colors.white, fontSize: 26.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
