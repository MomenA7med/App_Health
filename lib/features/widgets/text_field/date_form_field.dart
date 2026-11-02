// import 'package:flutter/material.dart';
// import 'package:app_health/core/widgets/base_stateful_widget.dart';
// import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
// import 'package:app_health/res/app_colors.dart';
// import 'package:app_health/res/app_icons.dart';
// import 'package:app_health/utils/format/app_date_format.dart';
//
// class DateFormField extends BaseStatefulWidget {
//   const DateFormField(
//       {super.key,
//       required this.validator,
//       required this.controller,
//       required this.hint,
//       required this.afterChooseDate,
//       this.initDate});
//
//   final String? Function(String?) validator;
//   final TextEditingController controller;
//   final DateTime? initDate;
//   final String hint;
//   final Function(DateTime date, String formattedDate) afterChooseDate;
//
//   @override
//   BaseState<DateFormField> baseCreateState() => _DateFormFieldState();
// }
//
// class _DateFormFieldState extends BaseState<DateFormField> {
//   @override
//   Widget baseBuild(BuildContext context) {
//     return AppTextFormField(
//       hintText: widget.hint,
//       validator: widget.validator,
//       onSaved: (value) {},
//       readOnly: true,
//       suffixIcon: const Icon(
//         Icons.calendar_today_outlined,
//         size: 20,
//         color: AppColors.calendarIcon,
//       ),
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: widget.initDate ?? DateTime.now(),
//           firstDate: DateTime(DateTime.now().year - 100),
//           //DateTime.now() - not to allow to choose before today.
//           lastDate: DateTime(DateTime.now().year + 100),
//         );
//         if (pickedDate != null) {
//           String formattedDate = AppDateFormat.formattingDate(
//               pickedDate, appLocale.locale.languageCode);
//           setState(() {
//             widget.controller.text =
//                 formattedDate; //set output date to TextField value.
//           });
//           widget.afterChooseDate(pickedDate, formattedDate);
//         }
//       },
//       textInputType: TextInputType.text,
//       controller: widget.controller,
//     );
//   }
// }
