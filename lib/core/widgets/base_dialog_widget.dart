import 'package:flutter/material.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required Widget dialogWidget,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        content: dialogWidget,
      );
    },
  );
}

Future<void> showAppModalBottomSheet(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: builder,
  );
}
