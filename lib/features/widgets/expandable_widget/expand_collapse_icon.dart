import 'package:flutter/material.dart';
import 'package:app_health/res/app_colors.dart';

class ExpandCollapseIcon extends StatefulWidget {
  final bool isExpanded;

  final double size;
  final Color color;

  const ExpandCollapseIcon({
    super.key,
    required this.isExpanded,
    this.size = 24.0,
    this.color = AppColors.appDropdownButtonFormFieldFill,
  });

  @override
  State<ExpandCollapseIcon> createState() => _ExpandCollapseIconState();
}

class _ExpandCollapseIconState extends State<ExpandCollapseIcon>
    with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 300);
  final IconData expandedIcon = Icons.keyboard_arrow_up_outlined;
  final IconData collapsedIcon = Icons.keyboard_arrow_down_outlined;

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: duration,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ExpandCollapseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationAnimation,
      child: Icon(
        widget.isExpanded ? expandedIcon : collapsedIcon,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
