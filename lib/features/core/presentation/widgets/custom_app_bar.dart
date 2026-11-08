import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/res/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext? context;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? screenTitle;
  final List<Widget>? actionsWidget;
  final bool showLocation;
  final String? locationText;
  final VoidCallback? onLocationTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? customTitleWidget;
  final double? preferredHeight;

  const CustomAppBar({
    super.key,
    this.context,
    this.scaffoldKey,
    this.screenTitle,
    this.actionsWidget,
    this.showLocation = false,
    this.locationText,
    this.onLocationTap,
    this.showBackButton = true,
    this.onBackTap,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.customTitleWidget,
    this.preferredHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight ?? 56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: showBackButton ? 64.w : null,
      leading: showBackButton ? _buildBackButton(context) : null,
      title: _buildTitle(context),
      actions: actionsWidget,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 20.w),
      child: Center(
        child: InkWell(
          onTap:
              onBackTap ??
              () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.pop();
                }
              },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Icon(
              Directionality.of(context) == TextDirection.ltr
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_rounded,
              size: 16.r,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (customTitleWidget != null) {
      return customTitleWidget;
    }
    if (showLocation) {
      return _buildLocationWidget(context);
    }
    if (screenTitle != null && screenTitle!.isNotEmpty) {
      return Text(
        screenTitle!,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.buttonBlackTextColor,
        ),
      );
    }
    return null;
  }

  Widget _buildLocationWidget(BuildContext context) {
    final String address =
        GetIt.I.isRegistered<UserMangers>()
            ? GetIt.I<UserMangers>().getAddress()
            : '';
    final String location =
        address.isNotEmpty
            ? address
            : (locationText ?? 'مدينة نصر، القاهرة');

    return InkWell(
      onTap: onLocationTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssetPaths.locationIcon,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.colorPrimary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              location,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(width: 4.w),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
