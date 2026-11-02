import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class RandersHtmlWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool useJustify;

  const RandersHtmlWidget({
    super.key,
    required this.text,
    this.style,
    this.useJustify = false,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      useJustify ? '<div style="text-align: justify">$text</div>' : text,
      textStyle: style,
    );
  }
}
