import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatelessWidget {
  final Widget collapsedWidget;
  final Widget expandedWidget;
  final bool initExpanded;
  final double borderRadius;
  final ExpandableController? controller;

  const ExpandableWidget({
    super.key,
    required this.collapsedWidget,
    required this.expandedWidget,
    this.borderRadius = 0,
    this.controller,
    this.initExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: controller != null ? null : initExpanded,
      controller: controller,
      child: ScrollOnExpand(
        child: Expandable(
          collapsed: _buildCollapsed(),
          expanded: _buildExpanded(),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    return Builder(
      builder: (context) {
        return InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _toggleExpanded(context),
          child: collapsedWidget,
        );
      },
    );
  }

  Widget _buildExpanded() {
    return Builder(
      builder: (context) {
        return InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _toggleExpanded(context),
          child: expandedWidget,
        );
      },
    );
  }

  void _toggleExpanded(BuildContext context) {
    var ctr = ExpandableController.of(context, required: true)!;
    ctr.toggle();
  }
}
