import 'package:flutter/material.dart';
import 'package:app_health/res/app_colors.dart';

class PagingSwipeToRefreshGridListWidget extends StatelessWidget {
  final VoidCallback reachedEndOfScroll;
  final Function(int index)? listItemClicked;
  final Widget Function(int index) itemWidget;
  final bool itemClickable;
  final Function swipedToRefresh;
  final int listLength;
  final bool showPagingLoader;
  final EdgeInsetsGeometry? listPadding;
  final double childAspectRatio;
  final Widget? widgetAboveList;

  const PagingSwipeToRefreshGridListWidget({
    super.key,
    required this.reachedEndOfScroll,
    this.listItemClicked,
    required this.itemClickable,
    required this.itemWidget,
    required this.swipedToRefresh,
    required this.listLength,
    required this.showPagingLoader,
    this.listPadding,
    this.childAspectRatio = 1.3,
    this.widgetAboveList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (isReachEndOfScrolling(scrollInfo)) {
                reachedEndOfScroll();
              }
              return false;
            },
            child: listWidget(),
          ),
        ),
        if (showPagingLoader) pagingLoadingWidget(showPagingLoader),
      ],
    );
  }

  bool isReachEndOfScrolling(ScrollNotification scrollInfo) {
    return (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent);
  }

  Widget listWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: [
          if (widgetAboveList != null) widgetAboveList!,
          Align(
            alignment: listLength == 1
                ? AlignmentDirectional.center
                : Alignment.center,
            child: GridView.builder(
              padding: listPadding ?? const EdgeInsets.only(top: 1, bottom: 20),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listLength,
              itemBuilder: (context, index) => _buildItemWidget(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(int index) {
    return itemWidget(index);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {});
    swipedToRefresh();
  }

  Widget pagingLoadingWidget(bool isLoading) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.all(10.0),
      height: isLoading ? 55.0 : 0,
      color: AppColors.paginationLoadingBackground,
      duration: const Duration(milliseconds: 300),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
