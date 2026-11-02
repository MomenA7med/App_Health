import 'package:flutter/material.dart';
import 'package:app_health/core/widgets/base_stateless_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlButton extends BaseStatelessWidget {
  final Uri uri;
  final double? fontSize;

  const UrlButton({super.key, this.fontSize, required this.uri});

  // Function to open the URL

  @override
  Widget baseBuild(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Text(uri.path, style: TextStyle(color: AppColors.linkText)),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showFeedbackMessage(
          "${context.translate(LocalizationKeys.couldNotLaunch)} ${uri.path}",
        );
      }
    }
  }
}
