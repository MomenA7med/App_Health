import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/utils/no_result/no_result_found.dart';

class SwipeToRefreshWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() swipedToRefresh;
  final bool alignCenter;

  const SwipeToRefreshWidget({
    super.key,
    required this.swipedToRefresh,
    this.child = const NoResultFoundWidget(),
    this.alignCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: alignCenter
          ? Align(
              alignment: Alignment.center,
              child: ListView(
                children: [
                  SizedBox(height: 250.h),
                  Center(child: child),
                ],
              ),
            )
          : child,
    );
  }

  Future<void> _refresh() async {
    return swipedToRefresh();
  }
}
