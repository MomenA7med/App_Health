import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_health/core/extensions/extension_theme.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class TimeFormFieldWidget extends StatelessWidget {
  final String? title;
  final bool requiredTitle;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TimeOfDay? initialValue;
  final FormFieldSetter<TimeOfDay> onSaved;
  final FormFieldValidator<TimeOfDay>? validator;
  final ValueChanged<TimeOfDay?>? onChangedDate;

  final TimeOfDay? value;
  final TimeOfDay? maximumDate;
  final TimeOfDay? minimumDate;
  final Color? formFieldFill;

  const TimeFormFieldWidget({
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
    this.formFieldFill,
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
          formFieldFill: formFieldFill,
          onChangedDate: onChangedDate,
        ),
      ],
    );
  }
}

class _DateSelectionFormField extends FormField<TimeOfDay> {
  _DateSelectionFormField({
    super.onSaved,
    super.validator,
    super.initialValue,
    String? hintText,
    TimeOfDay? maximumDate,
    TimeOfDay? minimumDate,
    Color? formFieldFill,
    ValueChanged<TimeOfDay?>? onChangedDate,
  }) : super(
         builder: (FormFieldState<TimeOfDay> state) {
           return Builder(
             builder: (context) {
               return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   InkWell(
                     onTap: () async {
                       // if (Platform.isAndroid) {
                       final TimeOfDay? picked = await showTimePicker(
                         context: state.context,
                         initialTime:
                             state.value ?? initialValue ?? TimeOfDay.now(),
                       );

                       if (picked != null && picked != state.value) {
                         state.didChange(picked);
                         onChangedDate?.call(picked);
                       }
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         color: formFieldFill ?? AppColors.appFormFieldFill,
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
                                   ? AppDateFormat.formattingTimeOfDay(
                                       state.value!,
                                       context,
                                     )
                                   : hintText ?? "",
                               style: state.value != null
                                   ? context.bodyMedium.copyWith(
                                       fontWeight: FontWeight.w600,
                                     )
                                   : context.titleSmall.copyWith(fontSize: 14),
                             ),
                             SvgPicture.asset(
                               AppAssetPaths.clockIcon,
                               height: 20,
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
