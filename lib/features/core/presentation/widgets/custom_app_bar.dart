import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final BuildContext context;
  final String screenTitle;
  final List<Widget>? actionsWidget;

  CustomAppBar({
    super.key,
    required this.context,
    this.scaffoldKey,
    required this.screenTitle,
    this.actionsWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget? get title => Text(screenTitle);

  @override
  bool? get centerTitle => true;

  @override
  List<Widget>? get actions => actionsWidget ?? (super.actions);

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
  );
}
