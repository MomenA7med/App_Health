import 'package:flutter/material.dart';

class CardWrapperWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radiusSize;
  final double? elevation;
  final EdgeInsetsGeometry margin;
  final VoidCallback? cardClickCallback;
  final Color? color;

  const CardWrapperWidget({
    required this.child,
    required this.padding,
    required this.radiusSize,
    this.elevation,
    this.margin = EdgeInsets.zero,
    this.cardClickCallback,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSize),
      ),
      elevation: elevation,
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusSize),
        onTap: cardClickCallback,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
