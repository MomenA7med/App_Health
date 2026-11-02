import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/extensions/extension_theme.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/format/app_date_format.dart';

/// Get default date based on range
/// - If minimumDate is not null and today is before it, return minimumDate
/// - If today is after maximumDate and minimumDate is null, return maximumDate
/// - If today is within range [minimumDate, maximumDate], return minimumDate
/// - If both minimumDate and maximumDate are null, return today
DateTime _getDefaultDate({DateTime? minimumDate, DateTime? maximumDate}) {
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // If both dates are null, return today
  if (minimumDate == null && maximumDate == null) {
    return today;
  }

  // If today is before minimum date, return minimum date
  if (minimumDate != null && today.isBefore(minimumDate)) {
    return minimumDate;
  }

  // If today is after maximum date and minimumDate is null, return maximum date
  if (maximumDate != null &&
      today.isAfter(maximumDate) &&
      minimumDate == null) {
    return maximumDate;
  }

  // Today is within range or minimumDate exists, return minimum date (first day of range)
  return minimumDate ?? today;
}

// ignore: must_be_immutable
class DateTimeFormFieldWidget extends StatelessWidget {
  final String? title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final DateTime? initialValue;
  final FormFieldSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime>? validator;
  final ValueChanged<DateTime?>? onChangedDate;

  final DateTime? value;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final bool showFullDay;

  const DateTimeFormFieldWidget({
    super.key,
    this.title,
    this.requiredTitle = true,
    this.hintText,
    this.labelText,
    this.helperText,
    this.initialValue,
    this.value,
    required this.onSaved,
    this.validator,
    this.onChangedDate,
    this.maximumDate,
    this.minimumDate,
    this.showFullDay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          LabelWithAsterisk(text: title!, showAsterisk: requiredTitle),
          const SizedBox(height: 10),
        ],
        _DateSelectionFormField(
          onSaved: onSaved,
          initialValue: initialValue,
          hintText: hintText,
          validator: validator,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          showFullDay: showFullDay,
          onChangedDate: onChangedDate,
        ),
        if (helperText != null) ...[
          Text(helperText!, style: context.bodyMedium.copyWith(fontSize: 12)),
        ],
      ],
    );
  }
}

class _DateSelectionFormField extends FormField<DateTime> {
  _DateSelectionFormField({
    super.onSaved,
    super.validator,
    super.initialValue,
    String? hintText,
    DateTime? maximumDate,
    DateTime? minimumDate,
    ValueChanged<DateTime?>? onChangedDate,
    required bool showFullDay,
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           return Builder(
             builder: (context) {
               return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   InkWell(
                     onTap: () async {
                       final defaultDate = _getDefaultDate(
                         minimumDate: minimumDate,
                         maximumDate: maximumDate,
                       );
                       if (Platform.isAndroid) {
                         final DateTime? picked = await showDatePicker(
                           context: state.context,
                           initialDate:
                               state.value ?? initialValue ?? defaultDate,
                           firstDate:
                               minimumDate ??
                               DateTime((DateTime.now().year - 100)),
                           lastDate:
                               maximumDate ??
                               DateTime((DateTime.now().year + 10)),
                         );

                         if (picked != null && picked != state.value) {
                           state.didChange(picked);
                           onChangedDate!(picked);
                         }
                       }
                       if (Platform.isIOS) {
                         // ignore: use_build_context_synchronously
                         await showCupertinoModalPopup<void>(
                           // ignore: use_build_context_synchronously
                           context: context,
                           builder: (BuildContext context) => Container(
                             height: 216,
                             padding: const EdgeInsets.only(top: 6.0),
                             // The Bottom margin is provided to align the popup above the system
                             // navigation bar.
                             margin: EdgeInsets.only(
                               bottom: MediaQuery.of(context).viewInsets.bottom,
                             ),
                             // Provide a background color for the popup.
                             color: CupertinoColors.systemBackground
                                 .resolveFrom(context),
                             // Use a SafeArea widget to avoid system overlaps.
                             child: SafeArea(
                               top: false,
                               child: CupertinoDatePicker(
                                 initialDateTime:
                                     state.value ?? initialValue ?? defaultDate,
                                 mode: CupertinoDatePickerMode.date,
                                 use24hFormat: true,
                                 maximumDate: maximumDate,
                                 minimumDate: minimumDate,
                                 // This is called when the user changes the date.
                                 onDateTimeChanged: (DateTime picked) {
                                   state.didChange(picked);
                                   onChangedDate!(picked);
                                 },
                               ),
                             ),
                           ),
                         ).then((_) {
                           if (state.value == null) {
                             state.didChange(
                               state.value ?? initialValue ?? defaultDate,
                             );
                             onSaved!(
                               state.value ?? initialValue ?? defaultDate,
                             );
                           }
                         });
                       }
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         color: AppColors.appFormFieldFill,
                         border: Border.all(
                           color: state.hasError
                               ? Theme.of(context).colorScheme.error
                               : AppColors.enabledAppFormFieldBorder,
                         ),
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Padding(
                         padding: EdgeInsets.symmetric(
                           horizontal: 12.w,
                           vertical: 12.h,
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               state.value != null
                                   ? showFullDay
                                         ? AppDateFormat.formattingDate(
                                             state.value!,
                                             context.languageKey,
                                           )
                                         : AppDateFormat.formattingOnlyMonthDay(
                                             state.value!,
                                             context.languageKey,
                                           )
                                   : hintText ?? "",
                               style: state.value != null
                                   ? context.bodyMedium.copyWith(
                                       fontWeight: FontWeight.w600,
                                     )
                                   : context.titleSmall.copyWith(fontSize: 14),
                             ),
                             SvgPicture.asset(
                               AppAssetPaths.calendarIcon,
                               colorFilter: const ColorFilter.mode(
                                 AppColors.suffixIcon,
                                 BlendMode.srcIn,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   const SizedBox(height: 8.0),
                   state.hasError
                       ? Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 15),
                           child: Text(
                             state.errorText!,
                             style: TextStyle(
                               color: Theme.of(context).colorScheme.error,
                               fontSize: 12.0,
                             ),
                           ),
                         )
                       : Container(),
                 ],
               );
             },
           );
         },
       );
}
