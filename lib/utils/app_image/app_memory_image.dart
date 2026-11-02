import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_health/utils/app_image/image_error_widget.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

class AppMemoryImage extends StatelessWidget {
  final String imageBase64;
  final double? width;
  final double? height;

  const AppMemoryImage({
    super.key,
    required this.imageBase64,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return imageBase64.isNotNullOrNotEmpty
        ? Image.memory(
            base64Decode(imageBase64),
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) => ImageErrorWidget(),
          )
        : const ImageErrorWidget();
  }
}
