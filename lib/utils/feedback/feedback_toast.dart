import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_health/res/app_colors.dart';

void showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.toastBackground,
    textColor: AppColors.toastText,
    fontSize: 16.0,
  );
}

/// reference
/// https://pub.dev/packages/fluttertoast
