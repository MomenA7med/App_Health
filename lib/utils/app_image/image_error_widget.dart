import 'package:flutter/material.dart';

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget() : super(key: const ValueKey("_ImageErrorWidget"));

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Center(
        child: Padding(padding: EdgeInsets.all(20.0), child: Icon(Icons.error)),
      ),
    );
  }
}
