import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final String imageUrl;

  const CustomNetworkImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      //加载过程中显示的占位符
      // placeholder: (context, url) => CustomFutureBuilder.loading(),
      placeholder: (context, url) => const Center(
        child: Text("图片正在加载..."),
      ),
      //加载失败时显示的hj占位符
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
