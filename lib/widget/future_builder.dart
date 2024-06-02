import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFutureBuilder {
  static Widget hasError(String error) {
    return Container(
      child: Center(
        child: Text(
          error,
          style: TextStyle(
            fontSize: 30.sp,
          ),
        ),
      ),
    );
  }

  static Widget loading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("正在加载中..."),
        ],
      ),
    );
  }
}
